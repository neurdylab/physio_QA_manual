clc
clear

% file stuff
dirlist = dir('../raw');
filelist = {dirlist.name};
filelist_size = size(filelist, 2);
filelist = filelist(:, 4:filelist_size);
file_count = size(filelist, 2);
%file_count = 4;
%num = 0;

% keep
for i = 1:file_count
    fname = filelist(1, i);
    %tsv_path = string(append('/Users/rachelyang/Desktop/raw/', fname, '/ses-BAS1/func/', fname, '_ses-BAS1_task-rest_acq-1400_physio.tsv'));
    %json_path = string(append('/Users/rachelyang/Desktop/raw/', fname, '/ses-BAS1/func/', fname, '_ses-BAS1_task-rest_acq-1400_physio.json'));
    tsv_path = string(append('/data1/neurdylab/datasets/nki_rockland/raw/', fname, '/ses-BAS1/func/', fname, '_ses-BAS1_task-rest_acq-1400_physio.tsv'));
    json_path = string(append('/data1/neurdylab/datasets/nki_rockland/raw/', fname, '/ses-BAS1/func/', fname, '_ses-BAS1_task-rest_acq-1400_physio.json'));
    
    if isfile(json_path) && isfile(tsv_path)
        % open json file
        fid = fopen(json_path); 
        raw = fread(fid,inf); 
        str = char(raw'); 
        fclose(fid); 
        val = jsondecode(str);
    
        % extracting information from struct val
        a = {val.Columns}; % a is an 1x1 array
        cols = a{1, 1}; % cols tells us the columns included in the physio file
        col_count = size(cols, 1);
        
        % open physio file
        phys = load(tsv_path);
        fs = 62.5;
        dt = 1/fs;
        num_samples = size(phys, 1);
        time_axis = [0 : dt : num_samples*dt - dt];
        
        figure; 
        set(gcf, 'color', 'white');
        
        % start plotting
        graph_count = 1;
        
        % plot trig first
        [trig_index, x] = find(strcmp(cols, 'trigger'));
        if (trig_index ~= -1)
            subplot(col_count, 1, graph_count);
            plot(time_axis, phys(:, trig_index));
            graph_count = graph_count + 1;
            ylabel('MRI trig'); ylim([0, 6]);
            title(fname, 'interpreter', 'none');
        end
        
        % plot others
        for j = 1:col_count
            
            % if have gsr
            if (strcmp(cols(j, 1), 'gsr'))
                subplot(col_count, 1, graph_count);
                plot(time_axis, phys(:, j));
                ylabel('GSR');
                if (graph_count == 1)
                    title(fname, 'interpreter', 'none');
                end
                graph_count = graph_count + 1;
            end
            
            % if have cardiac
            if (strcmp(cols(j, 1), 'cardiac'))
                subplot(col_count, 1, graph_count);
                plot(time_axis, phys(:, j));
                ylabel('cardiac');
                if (graph_count == 1)
                    title(fname, 'interpreter', 'none');
                end
                graph_count = graph_count + 1;
            end
            
            % if have respiratory
            if (strcmp(cols(j, 1), 'respiratory'))
                subplot(col_count, 1, graph_count);
                plot(time_axis, phys(:, j));
                ylabel('respiration');
                xlabel('time (s)');
                if (graph_count == 1)
                    title(fname, 'interpreter', 'none');
                end
                graph_count = graph_count + 1;
            end
            
            % if have column 'Custom, HLT100C - A 2'
            if (strcmp(cols(j, 1), 'Custom, HLT100C - A 1'))
                subplot(col_count, 1, graph_count);
                plot(time_axis, phys(:, j));
                ylabel('Custom, HLT100C - A 1');
                if(graph_count == 1)
                    title(fname, 'interpreter', 'none');
                end
                graph_count = graph_count + 1;
            end
            
            % if column is 'Custom, HLT100C - A 2'
            if (strcmp(cols(j, 1), 'Custom, HLT100C - A 2'))
                subplot(col_count, 1, graph_count);
                plot(time_axis, phys(:, j));
                ylabel('Custom, HTL100C - A 2');
                if(graph_count == 1)
                    title(fname, 'interpreter', 'non');
                end
                graph_count = graph_count + 1;
            end
            
        end
        saveas(gcf, string(append(fname, '_ses-BAS1_task-rest_acq-1400_physio.png')));   
    end
end
