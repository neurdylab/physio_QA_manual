classdef QA_App_modified_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        LabelPrompter                    matlab.ui.control.Label
        LoadButton1                            matlab.ui.control.Button
        LoadButton2                            matlab.ui.control.Button
        LoadButton3                            matlab.ui.control.Button
        DeleteButton1                            matlab.ui.control.Button
        DeleteButton2                            matlab.ui.control.Button
        DeleteButton3                            matlab.ui.control.Button
        PreviousButton                            matlab.ui.control.Button
        NextButton                            matlab.ui.control.Button
        IndexTracker                matlab.ui.control.Label
        Panel1                          matlab.ui.container.Panel
        Panel2                          matlab.ui.container.Panel
        Panel3                          matlab.ui.container.Panel

        SelectFieldPanel                          matlab.ui.container.Panel
        FieldsList                    matlab.ui.control.Label
        SelectFieldField            matlab.ui.control.EditField
        SelectFieldButton           matlab.ui.control.Button

        Label1                    matlab.ui.control.Label
        Label2                    matlab.ui.control.Label
        Label3                    matlab.ui.control.Label
        CommentField            matlab.ui.control.EditField
        AddCommentButton                            matlab.ui.control.Button
        GoField            matlab.ui.control.EditField
        GoButton                            matlab.ui.control.Button
        GreatButton1                            matlab.ui.control.Button
        GreatButton2                            matlab.ui.control.Button
        GreatButton3                            matlab.ui.control.Button
        FixableButton1                            matlab.ui.control.Button
        FixableButton2                            matlab.ui.control.Button
        FixableButton3                            matlab.ui.control.Button
        UncertainButton1                            matlab.ui.control.Button
        UncertainButton2                            matlab.ui.control.Button
        UncertainButton3                            matlab.ui.control.Button
        BadButton1                            matlab.ui.control.Button
        BadButton2                            matlab.ui.control.Button
        BadButton3                            matlab.ui.control.Button

    end

    
    properties (Access = public)
        
        dataPath = 'Data/'
        myTable = table();
        
        totalcount = 1; % keep track of total file numbers
        i = 1; % used to iterate through files
        loaded1 = false; % check if graph 1 has data loaded into it
        loaded2 = false;
        loaded3 = false;
        outfile = 'results.csv';

        fieldnames = [];
        fieldname;

        data1 = [];
        data2 = [];
        data3 = [];

        axes1;
        axes2;
        axes3;

        plot1;
        plot2;
        plot3;

    end
    
    methods (Access = private)
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            if exist(app.outfile, 'file') == 2
                % File exists, read the data from the CSV file into a table
                app.myTable = readtable(app.outfile, "Delimiter", ",");
                app.myTable = convertvars(app.myTable, app.myTable.Properties.VariableNames, 'string');
                filename = string(app.myTable{1+app.i,1});
                struct = load(strcat(app.dataPath, filename));
                app.fieldnames = fieldnames(struct);
                app.fieldname = string(app.myTable{1,2});
                
                fileNames = dir(fullfile(app.dataPath, '*.mat'));
                app.totalcount = length(fileNames);

                if ~ismissing(app.fieldname)
                    ts = struct.(app.fieldname);
                    app.Label1.Text = app.fieldname;
                    app.Label1.Visible = 'on';
                    if (size(ts, 1) == 1)
                        ts = ts';
                    end
        
                    app.axes1 = axes(app.Panel1, 'Position', [0.1 0.18 0.8 0.8]);
                    app.plot1 = plot(app.axes1, ts);
                    app.loaded1 = true;
                    
                end
                app.fieldname = string(app.myTable{1,3});
                if ~ismissing(app.fieldname)
                    ts = struct.(app.fieldname);
                    app.Label2.Text = app.fieldname;
                    app.Label2.Visible = 'on';
                    if (size(ts, 1) == 1)
                        ts = ts';
                    end
        
                    app.axes2 = axes(app.Panel2, 'Position', [0.1 0.18 0.8 0.8]);
                    app.plot2 = plot(app.axes2, ts);
                    app.loaded2 = true;
                end
                app.fieldname = string(app.myTable{1,4});
                if ~ismissing(app.fieldname)
                    ts = struct.(app.fieldname);
                    app.Label3.Text = app.fieldname;
                    app.Label3.Visible = 'on';

                    if (size(ts, 1) == 1)
                        ts = ts';
                    end
        
                    app.axes3 = axes(app.Panel3, 'Position', [0.1 0.18 0.8 0.8]);
                    app.plot3 = plot(app.axes3, ts);
                    app.loaded3 = true;
                end
            else
                fileNames = dir(fullfile(app.dataPath, '*.mat'));
                
                sz = [1+length(fileNames) 5];
                app.totalcount = length(fileNames);
                VariableNames = ["file_name", "first_graph", "second_graph", "third_graph", "comments"];
                VariableTypes = ["string", "string", "string", "string", "string"];
                app.myTable = table('Size', sz, 'VariableTypes', VariableTypes, 'VariableNames', VariableNames);
                app.myTable{1,1} = "field_name";
                
                for i = 1:length(fileNames)
                    app.myTable{1+i,1} = string(fileNames(i).name);
                end

                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end
               

        function SelectFieldButtonPushed(app, event)
            
            app.fieldname = app.SelectFieldField.Value;
            app.SelectFieldPanel.Visible = 'off';
            app.FieldsList.Text = string(app.fieldnames);
            app.FieldsList.Visible = 'off';
            app.SelectFieldButton.Visible = 'off';
            app.SelectFieldField.Visible = 'off';

        end
        
        % Button pushed function: Load the first plot
        function LoadButton1Pushed(app, event)
            
            filename = string(app.myTable{1+app.i,1});
            struct = load(strcat(app.dataPath, filename));
            app.fieldname = string(app.myTable{1,2});
            app.fieldnames = fieldnames(struct);
            app.SelectFieldPanel.Visible = 'on';
            app.FieldsList.Text = string(app.fieldnames);
            app.FieldsList.Visible = 'on';
            app.SelectFieldButton.Visible = 'on';
            app.SelectFieldField.Visible = 'on';
            waitfor(app,'fieldname');
            
            ts = struct.(app.fieldname);

            if (size(ts, 1) == 1)
                ts = ts';
            end

            
            app.axes1 = axes(app.Panel1, 'Position', [0.1 0.18 0.8 0.8]);
            app.plot1 = plot(app.axes1, ts);
            
            app.myTable{1,2} = string(app.fieldname);
            writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            app.Label1.Text = app.fieldname;
            app.Label1.Visible = 'on';
            app.loaded1 = true;

        end

        function LoadButton2Pushed(app, event)
            
            filename = string(app.myTable{1+app.i,1});
            struct = load(strcat(app.dataPath, filename));
            app.fieldname = string(app.myTable{1,3});
            app.fieldnames = fieldnames(struct);
            app.SelectFieldPanel.Visible = 'on';
            app.FieldsList.Text = string(app.fieldnames);
            app.FieldsList.Visible = 'on';
            app.SelectFieldButton.Visible = 'on';
            app.SelectFieldField.Visible = 'on';
            waitfor(app,'fieldname');
            
            ts = struct.(app.fieldname);

            if (size(ts, 1) == 1)
                ts = ts';
            end
            
            app.axes2 = axes(app.Panel2, 'Position', [0.1 0.18 0.8 0.8]);
            app.plot2 = plot(app.axes2, ts);
            app.myTable{1,3} = string(app.fieldname);
            writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            app.Label2.Text = app.fieldname;
            app.Label2.Visible = 'on';
            app.loaded2 = true;

        end

        function LoadButton3Pushed(app, event)
            
            filename = string(app.myTable{1+app.i,1});
            struct = load(strcat(app.dataPath, filename));
            app.fieldname = string(app.myTable{1,4});
            app.fieldnames = fieldnames(struct);
            app.SelectFieldPanel.Visible = 'on';
            app.FieldsList.Text = string(app.fieldnames);
            app.FieldsList.Visible = 'on';
            app.SelectFieldButton.Visible = 'on';
            app.SelectFieldField.Visible = 'on';
            waitfor(app,'fieldname');
            
            ts = struct.(app.fieldname);

            if (size(ts, 1) == 1)
                ts = ts';
            end
            
            
            app.axes3 = axes(app.Panel3, 'Position', [0.1 0.18 0.8 0.8]);
            app.plot3 = plot(app.axes3, ts);
            app.myTable{1,4} = string(app.fieldname);
            writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            app.Label3.Text = app.fieldname;
            app.Label3.Visible = 'on';
            app.loaded3 = true;
        end

        function DeleteButton1Pushed(app, event)
            if (app.loaded1)
                delete(app.axes1);
                app.myTable{:,2} = missing;
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
                app.Label1.Visible = 'off';
                app.loaded1 = false;
            end
        end

        function DeleteButton2Pushed(app, event)
            if (app.loaded2)
                delete(app.axes2);
                app.myTable{:,3} = missing;
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
                app.Label2.Visible = 'off';
                app.loaded2 = false;
            end
        end


        function DeleteButton3Pushed(app, event)
            if (app.loaded3)
                delete(app.axes3);
                app.myTable{:,4} = missing;
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
                app.Label3.Visible = 'off';
                app.loaded3 = false;
            end
        end

        function PreviousButtonPushed(app, event)
            
            if (app.i > 1)
                app.i = app.i - 1;
                app.IndexTracker.Text = strcat('Index:',{' '}, string(app.i));
                if (app.loaded1)
                    filename = string(app.myTable{1+app.i,1});
                    struct = load(strcat(app.dataPath, filename));
                    app.fieldname = string(app.myTable{1,2});
                    ts = struct.(app.fieldname);
                    cla(app.axes1);
                    app.plot1 = plot(app.axes1, ts);
                end
                if (app.loaded2)
                    filename = string(app.myTable{1+app.i,1});
                    struct = load(strcat(app.dataPath, filename));
                    app.fieldname = string(app.myTable{1,3});
                    ts = struct.(app.fieldname);
                    cla(app.axes2);
                    app.plot2 = plot(app.axes2, ts);
                end
                if (app.loaded3)
                    filename = string(app.myTable{1+app.i,1});
                    struct = load(strcat(app.dataPath, filename));
                    app.fieldname = string(app.myTable{1,4});
                    ts = struct.(app.fieldname);
                    cla(app.axes3);
                    app.plot3 = plot(app.axes3, ts);
                end
            
            end

        end

        function NextButtonPushed(app, event)
            
            if(app.i < app.totalcount)
                app.i = app.i + 1;
                app.IndexTracker.Text = strcat('Index:',{' '}, string(app.i));
                 if (app.loaded1)
                    filename = string(app.myTable{1+app.i,1});
                    struct = load(strcat(app.dataPath, filename));
                    app.fieldname = string(app.myTable{1,2});
                    ts = struct.(app.fieldname);
                    cla(app.axes1);
                    plot(app.axes1, ts);
                end
                if (app.loaded2)
                    filename = string(app.myTable{1+app.i,1});
                    struct = load(strcat(app.dataPath, filename));
                    app.fieldname = string(app.myTable{1,3});
                    ts = struct.(app.fieldname);
                    cla(app.axes2);
                    plot(app.axes2, ts);
                end
                if (app.loaded3)
                    filename = string(app.myTable{1+app.i,1});
                    struct = load(strcat(app.dataPath, filename));
                    app.fieldname = string(app.myTable{1,4});
                    ts = struct.(app.fieldname);
                    cla(app.axes3);
                    plot(app.axes3, ts);
                end
            
            end

        end

        function GoButtonPushed(app, event)
            
            value = str2double(app.GoField.Value);
            if (value >= 1 && value <= app.totalcount)
                app.i = value;
                app.IndexTracker.Text = strcat('Index:',{' '}, string(app.i));
                 if (app.loaded1)
                    ts = app.data1(app.i,:);
                    cla(app.axes1);
                    plot(app.axes1, ts);
                end
                if (app.loaded2)
                    ts = app.data2(app.i,:);
                    cla(app.axes2);
                    plot(app.axes2, ts);
                end
                if (app.loaded3)
                    ts = app.data3(app.i,:);
                    cla(app.axes3);
                    plot(app.axes3, ts);
                end
            
            end

        end
        
        function GreatButton1Pushed(app, event)
            if (app.loaded1)
                app.myTable{app.i + 1,2} = "great";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

        function GreatButton2Pushed(app, event)
            if (app.loaded2)
                app.myTable{app.i + 1,3} = "great";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end


        function GreatButton3Pushed(app, event)
            if (app.loaded3)
                app.myTable{app.i + 1,4} = "great";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

        function FixableButton1Pushed(app, event)
            if (app.loaded1)
                app.myTable{app.i + 1,2} = "fixable";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

        function FixableButton2Pushed(app, event)
            if (app.loaded2)
                app.myTable{app.i + 1,3} = "fixable";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end


        function FixableButton3Pushed(app, event)
            if (app.loaded3)
                app.myTable{app.i + 1,4} = "fixable";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

        function UncertainButton1Pushed(app, event)
            if (app.loaded1)
                app.myTable{app.i + 1,2} = "uncertain";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

        function UncertainButton2Pushed(app, event)
            if (app.loaded2)
                app.myTable{app.i + 1,3} = "uncertain";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end


        function UncertainButton3Pushed(app, event)
            if (app.loaded3)
                app.myTable{app.i + 1,4} = "uncertain";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

        function BadButton1Pushed(app, event)
            if (app.loaded1)
                app.myTable{app.i + 1,2} = "bad";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

        function BadButton2Pushed(app, event)
            if (app.loaded2)
                app.myTable{app.i + 1,3} = "bad";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end


        function BadButton3Pushed(app, event)
            if (app.loaded3)
                app.myTable{app.i + 1,4} = "bad";
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end


        function AddCommentButtonButtonPushed(app, event)
            if (app.loaded1)
                value = string(app.CommentField.Value);
                app.myTable{app.i + 1,5} = value;
                writetable(app.myTable, app.outfile, 'WriteRowNames',true');
            end
        end

    end



    

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1200 800];
            app.UIFigure.Name = 'Manual Annotation Tool';

            app.LabelPrompter = uilabel(app.UIFigure);
            app.LabelPrompter.FontName = 'Arial Black';
            app.LabelPrompter.FontSize = 12;
            app.LabelPrompter.FontWeight = 'bold';
            app.LabelPrompter.Position = [25 760 300 25];
            app.LabelPrompter.Text = 'Prompter';
            app.LabelPrompter.Visible = 'off';

            app.Panel1 = uipanel(app.UIFigure, 'Position', [150, 550, 900, 200], 'BackgroundColor', 'white');
            app.Panel2 = uipanel(app.UIFigure, 'Position', [150, 350, 900, 200], 'BackgroundColor', 'white');
            app.Panel3 = uipanel(app.UIFigure, 'Position', [150, 150, 900, 200], 'BackgroundColor', 'white');
            
            app.SelectFieldPanel = uipanel(app.UIFigure, 'Position', [300, 200, 600, 400], 'BackgroundColor', 'white');
            app.SelectFieldPanel.Visible = 'off';
            app.FieldsList = uilabel(app.UIFigure);
            app.FieldsList.FontName = 'Arial Black';
            app.FieldsList.FontSize = 12;
            app.FieldsList.Position = [320 200 560 380];
            app.FieldsList.WordWrap = 'on';
            app.FieldsList.VerticalAlignment = 'top';
            app.FieldsList.Visible = 'off';

            app.SelectFieldField = uieditfield(app.UIFigure, 'text');
            app.SelectFieldField .Position = [620 220 150 25];
            app.SelectFieldField .Placeholder = "Type field here";
            app.SelectFieldField.Visible = 'off';

            app.SelectFieldButton = uibutton(app.UIFigure, 'push');
            app.SelectFieldButton.ButtonPushedFcn = createCallbackFcn(app, @SelectFieldButtonPushed, true);
            app.SelectFieldButton.BackgroundColor = ['white'];
            app.SelectFieldButton.FontName = 'Arial Black';
            app.SelectFieldButton.FontSize = 12;
            app.SelectFieldButton.Position = [780 220 100 25];
            app.SelectFieldButton.Text = 'Choose field';
            app.SelectFieldButton.Visible = 'off';

            app.Label1 = uilabel(app.UIFigure);
            app.Label1.FontName = 'Arial Black';
            app.Label1.FontSize = 12;
            app.Label1.Position = [25 500 100 130];
            app.Label1.WordWrap = 'on';
            app.Label1.VerticalAlignment = 'top';
            app.Label1.Text = 'Label1';
            app.Label1.Visible = 'off';

            app.Label2 = uilabel(app.UIFigure);
            app.Label2.FontName = 'Arial Black';
            app.Label2.FontSize = 12;
            app.Label2.Position = [25 300 100 130];
            app.Label2.WordWrap = 'on';
            app.Label2.VerticalAlignment = 'top';
            app.Label2.Text = 'Label2';
            app.Label2.Visible = 'off';

            app.Label3 = uilabel(app.UIFigure);
            app.Label3.FontName = 'Arial Black';
            app.Label3.FontSize = 12;
            app.Label3.Position = [25 100 100 130];
            app.Label3.WordWrap = 'on';
            app.Label3.VerticalAlignment = 'top';
            app.Label3.Text = 'Label3';
            app.Label3.Visible = 'off';

            app.LoadButton1 = uibutton(app.UIFigure, 'push');
            app.LoadButton1.ButtonPushedFcn = createCallbackFcn(app, @LoadButton1Pushed, true);
            app.LoadButton1.BackgroundColor = ['white'];
            app.LoadButton1.FontName = 'Arial Black';
            app.LoadButton1.FontSize = 14;
            app.LoadButton1.Position = [25 700 100 50];
            app.LoadButton1.Text = 'Load';

            app.LoadButton2 = uibutton(app.UIFigure, 'push');
            app.LoadButton2.ButtonPushedFcn = createCallbackFcn(app, @LoadButton2Pushed, true);
            app.LoadButton2.BackgroundColor = ['white'];
            app.LoadButton2.FontName = 'Arial Black';
            app.LoadButton2.FontSize = 14;
            app.LoadButton2.Position = [25 500 100 50];
            app.LoadButton2.Text = 'Load';

            app.LoadButton3 = uibutton(app.UIFigure, 'push');
            app.LoadButton3.ButtonPushedFcn = createCallbackFcn(app, @LoadButton3Pushed, true);
            app.LoadButton3.BackgroundColor = ['white'];
            app.LoadButton3.FontName = 'Arial Black';
            app.LoadButton3.FontSize = 14;
            app.LoadButton3.Position = [25 300 100 50];
            app.LoadButton3.Text = 'Load';

            app.DeleteButton1 = uibutton(app.UIFigure, 'push');
            app.DeleteButton1.ButtonPushedFcn = createCallbackFcn(app, @DeleteButton1Pushed, true);
            app.DeleteButton1.BackgroundColor = ['white'];
            app.DeleteButton1.FontName = 'Arial Black';
            app.DeleteButton1.FontSize = 14;
            app.DeleteButton1.Position = [25 640 100 50];
            app.DeleteButton1.Text = 'Delete';

            app.DeleteButton2 = uibutton(app.UIFigure, 'push');
            app.DeleteButton2.ButtonPushedFcn = createCallbackFcn(app, @DeleteButton2Pushed, true);
            app.DeleteButton2.BackgroundColor = ['white'];
            app.DeleteButton2.FontName = 'Arial Black';
            app.DeleteButton2.FontSize = 14;
            app.DeleteButton2.Position = [25 440 100 50];
            app.DeleteButton2.Text = 'Delete';

            app.DeleteButton3 = uibutton(app.UIFigure, 'push');
            app.DeleteButton3.ButtonPushedFcn = createCallbackFcn(app, @DeleteButton3Pushed, true);
            app.DeleteButton3.BackgroundColor = ['white'];
            app.DeleteButton3.FontName = 'Arial Black';
            app.DeleteButton3.FontSize = 14;
            app.DeleteButton3.Position = [25 240 100 50];
            app.DeleteButton3.Text = 'Delete';

            app.PreviousButton = uibutton(app.UIFigure, 'push');
            app.PreviousButton.ButtonPushedFcn = createCallbackFcn(app, @PreviousButtonPushed, true);
            app.PreviousButton.BackgroundColor = ['white'];
            app.PreviousButton.FontName = 'Arial Black';
            app.PreviousButton.FontSize = 12;
            app.PreviousButton.Position = [840 760 100 25];
            app.PreviousButton.Text = 'Previous';

            app.NextButton = uibutton(app.UIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.BackgroundColor = ['white'];
            app.NextButton.FontName = 'Arial Black';
            app.NextButton.FontSize = 12;
            app.NextButton.Position = [950 760 100 25];
            app.NextButton.Text = 'Next';

            app.IndexTracker = uilabel(app.UIFigure);
            app.IndexTracker.FontName = 'Arial Black';
            app.IndexTracker.FontSize = 12;
            app.IndexTracker.FontWeight = 'bold';
            app.IndexTracker.Position = [1080 760 100 25];
            app.IndexTracker.Text = strcat('Index:',{' '}, string(app.i));

            app.GoField = uieditfield(app.UIFigure, 'text');
            app.GoField.Position = [620 760 100 25];
            app.GoField.Placeholder = "Subject #";

            app.GoButton = uibutton(app.UIFigure, 'push');
            app.GoButton.ButtonPushedFcn = createCallbackFcn(app, @GoButtonPushed, true);
            app.GoButton.BackgroundColor = ['white'];
            app.GoButton.FontName = 'Arial Black';
            app.GoButton.FontSize = 12;
            app.GoButton.Position = [730 760 100 25];
            app.GoButton.Text = 'Go';
            
            app.GreatButton1 = uibutton(app.UIFigure, 'push');
            app.GreatButton1.ButtonPushedFcn = createCallbackFcn(app, @GreatButton1Pushed, true);
            app.GreatButton1.BackgroundColor = ['green'];
            app.GreatButton1.FontName = 'Arial Black';
            app.GreatButton1.FontSize = 14;
            app.GreatButton1.Position = [1075 705 100 40];
            app.GreatButton1.Text = 'Great';

            app.GreatButton2 = uibutton(app.UIFigure, 'push');
            app.GreatButton2.ButtonPushedFcn = createCallbackFcn(app, @GreatButton2Pushed, true);
            app.GreatButton2.BackgroundColor = ['green'];
            app.GreatButton2.FontName = 'Arial Black';
            app.GreatButton2.FontSize = 14;
            app.GreatButton2.Position = [1075 505 100 40];
            app.GreatButton2.Text = 'Great';

            app.GreatButton3 = uibutton(app.UIFigure, 'push');
            app.GreatButton3.ButtonPushedFcn = createCallbackFcn(app, @GreatButton3Pushed, true);
            app.GreatButton3.BackgroundColor = ['green'];
            app.GreatButton3.FontName = 'Arial Black';
            app.GreatButton3.FontSize = 14;
            app.GreatButton3.Position = [1075 305 100 40];
            app.GreatButton3.Text = 'Great';

            app.FixableButton1 = uibutton(app.UIFigure, 'push');
            app.FixableButton1.ButtonPushedFcn = createCallbackFcn(app, @FixableButton1Pushed, true);
            app.FixableButton1.BackgroundColor = ['cyan'];
            app.FixableButton1.FontName = 'Arial Black';
            app.FixableButton1.FontSize = 14;
            app.FixableButton1.Position = [1075 655 100 40];
            app.FixableButton1.Text = 'Fixable';

            app.FixableButton2 = uibutton(app.UIFigure, 'push');
            app.FixableButton2.ButtonPushedFcn = createCallbackFcn(app, @FixableButton2Pushed, true);
            app.FixableButton2.BackgroundColor = ['cyan'];
            app.FixableButton2.FontName = 'Arial Black';
            app.FixableButton2.FontSize = 14;
            app.FixableButton2.Position = [1075 455 100 40];
            app.FixableButton2.Text = 'Fixable';

            app.FixableButton3 = uibutton(app.UIFigure, 'push');
            app.FixableButton3.ButtonPushedFcn = createCallbackFcn(app, @FixableButton3Pushed, true);
            app.FixableButton3.BackgroundColor = ['cyan'];
            app.FixableButton3.FontName = 'Arial Black';
            app.FixableButton3.FontSize = 14;
            app.FixableButton3.Position = [1075 255 100 40];
            app.FixableButton3.Text = 'Fixable';

            app.UncertainButton1 = uibutton(app.UIFigure, 'push');
            app.UncertainButton1.ButtonPushedFcn = createCallbackFcn(app, @UncertainButton1Pushed, true);
            app.UncertainButton1.BackgroundColor = ['yellow'];
            app.UncertainButton1.FontName = 'Arial Black';
            app.UncertainButton1.FontSize = 14;
            app.UncertainButton1.Position = [1075 605 100 40];
            app.UncertainButton1.Text = 'Uncertain';

            app.UncertainButton2 = uibutton(app.UIFigure, 'push');
            app.UncertainButton2.ButtonPushedFcn = createCallbackFcn(app, @UncertainButton2Pushed, true);
            app.UncertainButton2.BackgroundColor = ['yellow'];
            app.UncertainButton2.FontName = 'Arial Black';
            app.UncertainButton2.FontSize = 14;
            app.UncertainButton2.Position = [1075 405 100 40];
            app.UncertainButton2.Text = 'Uncertain';

            app.UncertainButton3 = uibutton(app.UIFigure, 'push');
            app.UncertainButton3.ButtonPushedFcn = createCallbackFcn(app, @UncertainButton3Pushed, true);
            app.UncertainButton3.BackgroundColor = ['yellow'];
            app.UncertainButton3.FontName = 'Arial Black';
            app.UncertainButton3.FontSize = 14;
            app.UncertainButton3.Position = [1075 205 100 40];
            app.UncertainButton3.Text = 'Uncertain';

            app.BadButton1 = uibutton(app.UIFigure, 'push');
            app.BadButton1.ButtonPushedFcn = createCallbackFcn(app, @BadButton1Pushed, true);
            app.BadButton1.BackgroundColor = ['red'];
            app.BadButton1.FontName = 'Arial Black';
            app.BadButton1.FontSize = 14;
            app.BadButton1.Position = [1075 555 100 40];
            app.BadButton1.Text = 'Bad';

            app.BadButton2 = uibutton(app.UIFigure, 'push');
            app.BadButton2.ButtonPushedFcn = createCallbackFcn(app, @BadButton2Pushed, true);
            app.BadButton2.BackgroundColor = ['red'];
            app.BadButton2.FontName = 'Arial Black';
            app.BadButton2.FontSize = 14;
            app.BadButton2.Position = [1075 355 100 40];
            app.BadButton2.Text = 'Bad';

            app.BadButton3 = uibutton(app.UIFigure, 'push');
            app.BadButton3.ButtonPushedFcn = createCallbackFcn(app, @BadButton3Pushed, true);
            app.BadButton3.BackgroundColor = ['red'];
            app.BadButton3.FontName = 'Arial Black';
            app.BadButton3.FontSize = 14;
            app.BadButton3.Position = [1075 155 100 40];
            app.BadButton3.Text = 'Bad';

            app.CommentField = uieditfield(app.UIFigure, 'text');
            app.CommentField.Position = [100 50 1000 75]   ;
            app.CommentField.Placeholder = "Add comments here";

            app.AddCommentButton = uibutton(app.UIFigure, 'push');
            app.AddCommentButton.ButtonPushedFcn = createCallbackFcn(app, @AddCommentButtonButtonPushed, true);
            app.AddCommentButton.BackgroundColor = ['white'];
            app.AddCommentButton.FontName = 'Arial Black';
            app.AddCommentButton.FontSize = 12;
            app.AddCommentButton.Position = [975 15 125 25];
            app.AddCommentButton.Text = 'Save Comment';

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