classdef QA_App_modified_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        AddcommentButton                matlab.ui.control.Button
        InputSubjectNoEditField_2       matlab.ui.control.EditField
        InputSubjectNoEditFieldLabel_2  matlab.ui.control.Label
        BadRespiration                  matlab.ui.control.Button
        UncertainRespiration            matlab.ui.control.Button
        GoodRespiration                 matlab.ui.control.Button
        RespirationLabel                matlab.ui.control.Label
        BadCardiac                      matlab.ui.control.Button
        UncertainCardiac                matlab.ui.control.Button
        GoodCardiac                     matlab.ui.control.Button
        CardiacLabel                    matlab.ui.control.Label
        GoButton                        matlab.ui.control.Button
        InputSubjectNoEditField         matlab.ui.control.EditField
        InputSubjectNoEditFieldLabel    matlab.ui.control.Label
        ClickLoadtostartLabel           matlab.ui.control.Label
        NextButton                      matlab.ui.control.Button
        PreviousButton                  matlab.ui.control.Button
        Image                           matlab.ui.control.Image
        UncertainButton                 matlab.ui.control.Button
        BadButton                       matlab.ui.control.Button
        GoodButton                      matlab.ui.control.Button
        GreatButton                     matlab.ui.control.Button
        GreatCardiac                    matlab.ui.control.Button
        GreatRespiration                matlab.ui.control.Button
    end

    
    properties (Access = public)
        myPath = '/Users/rg/Documents/physio';

        class = cell(0);
        cardiac = cell(0);
        respiration = cell(0);
        comment = cell(0);
        myTable = table();
        count = 0;
        filenames = [];
        filecount = 0; % keep track of total file numbers
        i = 0; % used to iterate through files
        loaded = false;

        sorted_or_not = []
        sorted_or_not_c = []
        sorted_or_not_r = []
    end
    
    methods (Access = private)
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
            %----------------------------
            % Check for output csv file that contains sorting information.
            % If the file does not exist(i.e. first time using this app),
            % create a new one. If output file exist, read the file into a
            % table    
            %----------------------------
            % Check if the CSV file exists
            filepath = strcat(app.myPath,'/Plots/');
            dirlist = dir(strcat(app.myPath, '/Plots'));
            outfilepath = strcat(app.myPath, '/result.csv');
            if exist(outfilepath, 'file') == 2
                % File exists, read the data from the CSV file into a table
                app.myTable = readtable(outfilepath);
            else
                % File doesn't exist, create a table from PNG files in a folder
                folderPath = strcat(app.myPath, '/Plots/'); % Replace with the actual path to your folder
                fileNames = dir(fullfile(folderPath, '*.png')); % Get a list of all PNG files in the folder
        
                % Create a cell array to store the file names
                fileNamesCell = cell(numel(fileNames), 1);
        
                % Loop through the file names and extract the subject
                % names(e.g. sub-A00038189)
                for i = 1:numel(fileNames)
                    fileName = fileNames(i).name(1:21);
                    fileNamesCell{i} = strrep(fileName, '_', '-');
                end
        
                % Create the table using the file names
                data = table(fileNamesCell, 'VariableNames', {'FileName'});

                % Now add additional columns - Class("good", "bad","uncertain"), comments
                % Get the number of rows in the table
                numRows = height(data);

                % Add two blank columns by assigning empty data with the same number of rows
                data.Class = cell(numRows, 1);
                data.Cardiac = cell(numRows, 1);
                data.Respiration = cell(numRows, 1);
                data.Comment = cell(numRows, 1); 
                app.myTable = data;
        
                % Write the table to a new CSV file
                writetable(app.myTable, outfilepath);
            end
            
            % extract the class column from the table and populate the app
            % property "class"
            app.class = table2cell(app.myTable(:, "Class"));
            app.respiration = table2cell(app.myTable(:, "Respiration"));
            app.cardiac = table2cell(app.myTable(:, "Cardiac"));
            app.comment = table2cell(app.myTable(:, "Comment"));
            
            %----------------------------
            % Load and display plots
            %----------------------------
            
            % update iterator
            app.i = app.i + 1;
        
            % load files and store file names in 'filenames'
            filelist = {dirlist.name};
            filelist_size = size(filelist, 2);
            app.filenames = filelist(:, 4:filelist_size);
            app.filecount = size(app.filenames, 2);
        
            % set image to first file
            path = string(append(filepath, app.filenames(1, 1)));
            app.Image.ImageSource = path;
        
            % set label to subject label
            cur_filename = char(app.filenames(1, app.i));
            cur_filename = cur_filename(1:21);
            app.ClickLoadtostartLabel.Text = cur_filename;
        
            % update bool
            app.loaded = true;
        
            % udpate sorted_or_not array
            app.sorted_or_not = ones(1, app.filecount)*false;
            app.sorted_or_not_c = ones(1, app.filecount)*false;
            app.sorted_or_not_r = ones(1, app.filecount)*false;
                
        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            filepath = strcat(app.myPath,'/Plots/');
            if app.loaded == false
                app.ClickLoadtostartLabel.Text = "Please load file first by clicking the load button";
            else
                if app.i <= (app.filecount - 1)
                    % update iterator
                    app.i = app.i + 1;
                
                    % set image to first file
                    path = string(append(filepath, app.filenames(1, app.i)));
                    %app.Label2.Text = path;
                    app.Image.ImageSource = path;
            
                    % set label to subject label
                    cur_filename = char(app.filenames(1, app.i));
                    cur_filename = cur_filename(1:21);
                    app.ClickLoadtostartLabel.Text = cur_filename;
                    
                % if reached last file, 
                elseif app.i == app.filecount
                    app.ClickLoadtostartLabel.Text = 'This is the last file';
                end
            end

        end

        % Button pushed function: PreviousButton
        function PreviousButtonPushed(app, event)
            filepath = strcat(app.myPath,'/Plots/');
            if app.loaded == false
                app.ClickLoadtostartLabel.Text = "Please load file first by clicking the load button";
            else
                if app.i >= 2
                    % update iterator
                    app.i = app.i - 1;
                
                    % set image to first file
                    path = string(append(filepath, app.filenames(1, app.i)));
                    %app.Label2.Text = path;
                    app.Image.ImageSource = path;
            
                    % set label to subject label
                    cur_filename = char(app.filenames(1, app.i));
                    cur_filename = cur_filename(1:21);
                    app.ClickLoadtostartLabel.Text = cur_filename;
                    
                % if reached last file, 
                elseif app.i == 1
                    app.ClickLoadtostartLabel.Text = 'This is the first file';
                end
            end
        end


        % Button pushed function: GreatButton
        function GreatButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.class{app.i} = "great";
            app.myTable.Class = app.class;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: GoodButton
        function GoodButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.class{app.i} = "good";
            app.myTable.Class = app.class;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: UncertainButton
        function UncertainButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.class{app.i} = "uncertain";
            app.myTable.Class = app.class;
            writetable(app.myTable, outfilepath);
        end

        % Callback function: BadButton, Image
        function BadButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.class{app.i} = "bad";
            app.myTable.Class = app.class;
            writetable(app.myTable, outfilepath);
 
        end

        % Button pushed function: GoButton
        function GoButtonPushed(app, event)
            filepath = strcat(app.myPath,'/Plots/');
            value = app.InputSubjectNoEditField.Value;
            
            %app.Label2.Text = value;
            if ~isempty(app.filenames)
                
                tmp = find(contains(app.filenames, value));
                
                if length(tmp) ~= 1
                    app.ClickLoadtostartLabel.Text = "Number not descriptive enough";
                else
                    
                    app.i = tmp;
                    
                    % set image to first file
                    path = string(append(filepath, app.filenames(1, app.i)));
                    app.Image.ImageSource = path;
            
                    % set label to subject label
                    cur_filename = char(app.filenames(1, app.i));
                    cur_filename = cur_filename(1:21);
                    app.ClickLoadtostartLabel.Text = cur_filename;
                end
            else
                app.ClickLoadtostartLabel.Text = "Load files first";
            end
            
        end

        % Button pushed function: GreatCardiac
        function GreatCardiacButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.cardiac{app.i} = "great";
            app.myTable.Cardiac = app.cardiac;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: GoodCardiac
        function GoodCardiacButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.cardiac{app.i} = "good";
            app.myTable.Cardiac = app.cardiac;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: BadCardiac
        function BadCardiacButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.cardiac{app.i} = "bad";
            app.myTable.Cardiac = app.cardiac;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: UncertainCardiac
        function UncertainCardiacButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.cardiac{app.i} = "uncertain";
            app.myTable.Cardiac = app.cardiac;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: UncertainRespiration
        function UncertainRespirationButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.respiration{app.i} = "uncertain";
            app.myTable.Respiration = app.respiration;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: BadRespiration
        function BadRespirationButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.respiration{app.i} = "bad";
            app.myTable.Respiration = app.respiration;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: GoodRespiration
        function GoodRespirationButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.respiration{app.i} = "good";
            app.myTable.Respiration = app.respiration;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: GreatRespiration
        function GreatRespirationButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            app.respiration{app.i} = "great";
            app.myTable.Respiration = app.respiration;
            writetable(app.myTable, outfilepath);
        end

        % Button pushed function: AddcommentButton
        function AddcommentButtonPushed(app, event)
            outfilepath = strcat(app.myPath, '/result.csv');
            value = app.InputSubjectNoEditField_2.Value;
            app.comment{app.i} = value;
            app.myTable.Comment = app.comment;
            writetable(app.myTable, outfilepath);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.8431 0.9255 0.9804];
            app.UIFigure.Position = [100 100 1230 826];
            app.UIFigure.Name = 'MATLAB App';

            % Create GreatButton
            app.GreatButton = uibutton(app.UIFigure, 'push');
            app.GreatButton.ButtonPushedFcn = createCallbackFcn(app, @GreatButtonPushed, true);
            app.GreatButton.BackgroundColor = [0 1 0];
            app.GreatButton.FontName = 'Arial Black';
            app.GreatButton.FontSize = 17;
            app.GreatButton.FontWeight = 'bold';
            app.GreatButton.Position = [400 39 100 43];
            app.GreatButton.Text = 'Great';

            % Create GoodButton
            app.GoodButton = uibutton(app.UIFigure, 'push');
            app.GoodButton.ButtonPushedFcn = createCallbackFcn(app, @GoodButtonPushed, true);
            app.GoodButton.BackgroundColor = [0 1 0];
            app.GoodButton.FontName = 'Arial Black';
            app.GoodButton.FontSize = 17;
            app.GoodButton.FontWeight = 'bold';
            app.GoodButton.Position = [550 39 100 43];
            app.GoodButton.Text = 'Good';

            % Create UncertainButton
            app.UncertainButton = uibutton(app.UIFigure, 'push');
            app.UncertainButton.ButtonPushedFcn = createCallbackFcn(app, @UncertainButtonPushed, true);
            app.UncertainButton.BackgroundColor = [1 1 0];
            app.UncertainButton.FontName = 'Arial Black';
            app.UncertainButton.FontSize = 17;
            app.UncertainButton.FontWeight = 'bold';
            app.UncertainButton.Position = [700 39 100 43];
            app.UncertainButton.Text = 'Uncertain';
            
            % Create BadButton
            app.BadButton = uibutton(app.UIFigure, 'push');
            app.BadButton.ButtonPushedFcn = createCallbackFcn(app, @BadButtonPushed, true);
            app.BadButton.BackgroundColor = [1 0 0];
            app.BadButton.FontName = 'Arial Black';
            app.BadButton.FontSize = 17;
            app.BadButton.FontWeight = 'bold';
            app.BadButton.Position = [850 39 100 43];
            app.BadButton.Text = 'Bad';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ImageClickedFcn = createCallbackFcn(app, @BadButtonPushed, true);
            app.Image.Position = [-118 217 1182 545];

            % Create PreviousButton
            app.PreviousButton = uibutton(app.UIFigure, 'push');
            app.PreviousButton.ButtonPushedFcn = createCallbackFcn(app, @PreviousButtonPushed, true);
            app.PreviousButton.BackgroundColor = [1 1 1];
            app.PreviousButton.FontName = 'Arial Black';
            app.PreviousButton.FontSize = 16;
            app.PreviousButton.Position = [50 85 106 46];
            app.PreviousButton.Text = 'Previous';

            % Create NextButton
            app.NextButton = uibutton(app.UIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.BackgroundColor = [1 1 1];
            app.NextButton.FontName = 'Arial Black';
            app.NextButton.FontSize = 16;
            app.NextButton.FontWeight = 'bold';
            app.NextButton.Position = [1050 81 105 46];
            app.NextButton.Text = 'Next';

            % Create ClickLoadtostartLabel
            app.ClickLoadtostartLabel = uilabel(app.UIFigure);
            app.ClickLoadtostartLabel.FontName = 'Arial Black';
            app.ClickLoadtostartLabel.FontSize = 15;
            app.ClickLoadtostartLabel.FontWeight = 'bold';
            app.ClickLoadtostartLabel.Position = [26 785 289 24];
            app.ClickLoadtostartLabel.Text = 'Click "Load" to start!';

            % Create InputSubjectNoEditFieldLabel
            app.InputSubjectNoEditFieldLabel = uilabel(app.UIFigure);
            app.InputSubjectNoEditFieldLabel.HorizontalAlignment = 'right';
            app.InputSubjectNoEditFieldLabel.FontName = 'Arial Black';
            app.InputSubjectNoEditFieldLabel.FontSize = 14;
            app.InputSubjectNoEditFieldLabel.Position = [740 782 170 22];
            app.InputSubjectNoEditFieldLabel.Text = 'Input Subject Number';

            % Create InputSubjectNoEditField
            app.InputSubjectNoEditField = uieditfield(app.UIFigure, 'text');
            app.InputSubjectNoEditField.Position = [921 782 100 22];

            % Create GoButton
            app.GoButton = uibutton(app.UIFigure, 'push');
            app.GoButton.ButtonPushedFcn = createCallbackFcn(app, @GoButtonPushed, true);
            app.GoButton.BackgroundColor = [0.6588 1 0.698];
            app.GoButton.FontName = 'Arial Black';
            app.GoButton.FontSize = 15;
            app.GoButton.FontWeight = 'bold';
            app.GoButton.Position = [1041 778 68 31];
            app.GoButton.Text = 'Go';

            % Create CardiacLabel
            app.CardiacLabel = uilabel(app.UIFigure);
            app.CardiacLabel.FontName = 'Arial Black';
            app.CardiacLabel.FontSize = 16;
            app.CardiacLabel.FontWeight = 'bold';
            app.CardiacLabel.Position = [250 98 73 25];
            app.CardiacLabel.Text = 'Cardiac';

            % Create GreatCardiac
            app.GreatCardiac = uibutton(app.UIFigure, 'push');
            app.GreatCardiac.ButtonPushedFcn = createCallbackFcn(app, @GreatCardiacButtonPushed, true);
            app.GreatCardiac.BackgroundColor = [0.6863 0.9882 0.6039];
            app.GreatCardiac.FontName = 'Arial Black';
            app.GreatCardiac.FontSize = 14;
            app.GreatCardiac.FontWeight = 'bold';
            app.GreatCardiac.Position = [400 93 100 30];
            app.GreatCardiac.Text = 'Great';

            % Create GoodCardiac
            app.GoodCardiac = uibutton(app.UIFigure, 'push');
            app.GoodCardiac.ButtonPushedFcn = createCallbackFcn(app, @GoodCardiacButtonPushed, true);
            app.GoodCardiac.BackgroundColor = [0.6863 0.9882 0.6039];
            app.GoodCardiac.FontName = 'Arial Black';
            app.GoodCardiac.FontSize = 14;
            app.GoodCardiac.FontWeight = 'bold';
            app.GoodCardiac.Position = [550 93 100 30];
            app.GoodCardiac.Text = 'Good';

            % Create UncertainCardiac
            app.UncertainCardiac = uibutton(app.UIFigure, 'push');
            app.UncertainCardiac.ButtonPushedFcn = createCallbackFcn(app, @UncertainCardiacButtonPushed, true);
            app.UncertainCardiac.BackgroundColor = [0.9765 0.9882 0.702];
            app.UncertainCardiac.FontName = 'Arial Black';
            app.UncertainCardiac.FontSize = 14;
            app.UncertainCardiac.FontWeight = 'bold';
            app.UncertainCardiac.Position = [700 93 100 30];
            app.UncertainCardiac.Text = 'Uncertain';

            % Create BadCardiac
            app.BadCardiac = uibutton(app.UIFigure, 'push');
            app.BadCardiac.ButtonPushedFcn = createCallbackFcn(app, @BadCardiacButtonPushed, true);
            app.BadCardiac.BackgroundColor = [1 0.6784 0.6784];
            app.BadCardiac.FontName = 'Arial Black';
            app.BadCardiac.FontSize = 14;
            app.BadCardiac.FontWeight = 'bold';
            app.BadCardiac.Position = [850 93 100 30];
            app.BadCardiac.Text = 'Bad';

            % Create RespirationLabel
            app.RespirationLabel = uilabel(app.UIFigure);
            app.RespirationLabel.FontName = 'Arial Black';
            app.RespirationLabel.FontSize = 16;
            app.RespirationLabel.FontWeight = 'bold';
            app.RespirationLabel.Position = [250 137 106 25];
            app.RespirationLabel.Text = 'Respiration';

            % Create GreatRespiration
            app.GreatRespiration = uibutton(app.UIFigure, 'push');
            app.GreatRespiration.ButtonPushedFcn = createCallbackFcn(app, @GreatRespirationButtonPushed, true);
            app.GreatRespiration.BackgroundColor = [0.6863 0.9882 0.6039];
            app.GreatRespiration.FontName = 'Arial Black';
            app.GreatRespiration.FontSize = 14;
            app.GreatRespiration.FontWeight = 'bold';
            app.GreatRespiration.Position = [400 133 100 33];
            app.GreatRespiration.Text = 'Great';


            % Create GoodRespiration
            app.GoodRespiration = uibutton(app.UIFigure, 'push');
            app.GoodRespiration.ButtonPushedFcn = createCallbackFcn(app, @GoodRespirationButtonPushed, true);
            app.GoodRespiration.BackgroundColor = [0.6863 0.9882 0.6039];
            app.GoodRespiration.FontName = 'Arial Black';
            app.GoodRespiration.FontSize = 14;
            app.GoodRespiration.FontWeight = 'bold';
            app.GoodRespiration.Position = [550 133 100 33];
            app.GoodRespiration.Text = 'Good';

            % Create UncertainRespiration
            app.UncertainRespiration = uibutton(app.UIFigure, 'push');
            app.UncertainRespiration.ButtonPushedFcn = createCallbackFcn(app, @UncertainRespirationButtonPushed, true);
            app.UncertainRespiration.BackgroundColor = [0.9765 0.9882 0.702];
            app.UncertainRespiration.FontName = 'Arial Black';
            app.UncertainRespiration.FontSize = 14;
            app.UncertainRespiration.FontWeight = 'bold';
            app.UncertainRespiration.Position = [700 133 100 33];
            app.UncertainRespiration.Text = 'Uncertain';

            % Create BadRespiration
            app.BadRespiration = uibutton(app.UIFigure, 'push');
            app.BadRespiration.ButtonPushedFcn = createCallbackFcn(app, @BadRespirationButtonPushed, true);
            app.BadRespiration.BackgroundColor = [1 0.6784 0.6784];
            app.BadRespiration.FontName = 'Arial Black';
            app.BadRespiration.FontSize = 14;
            app.BadRespiration.Position = [850 133 100 33];
            app.BadRespiration.Text = 'Bad';

            % Create InputSubjectNoEditFieldLabel_2
            app.InputSubjectNoEditFieldLabel_2 = uilabel(app.UIFigure);
            app.InputSubjectNoEditFieldLabel_2.HorizontalAlignment = 'right';
            app.InputSubjectNoEditFieldLabel_2.FontName = 'Arial Black';
            app.InputSubjectNoEditFieldLabel_2.FontSize = 16;
            app.InputSubjectNoEditFieldLabel_2.Position = [1103 666 89 25];
            app.InputSubjectNoEditFieldLabel_2.Text = 'Comment';

            % Create InputSubjectNoEditField_2
            app.InputSubjectNoEditField_2 = uieditfield(app.UIFigure, 'text');
            app.InputSubjectNoEditField_2.Position = [921 574 285 83];

            % Create AddcommentButton
            app.AddcommentButton = uibutton(app.UIFigure, 'push');
            app.AddcommentButton.ButtonPushedFcn = createCallbackFcn(app, @AddcommentButtonPushed, true);
            app.AddcommentButton.BackgroundColor = [1 1 1];
            app.AddcommentButton.FontName = 'Arial Black';
            app.AddcommentButton.FontSize = 15;
            app.AddcommentButton.FontWeight = 'bold';
            app.AddcommentButton.Position = [1077 521 129 31];
            app.AddcommentButton.Text = 'Add comment';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = QA_App_modified_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end