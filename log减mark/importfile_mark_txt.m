function [Trial_mark,Subject_mark,Color_mark,Name_mark,Stimulus_mark,StartTimems,EndTimems,TriggerLineStartms,TriggerLineDurationms,TriggerLineEndms,Number,PortStatus] = importfile(filename, startRow, endRow)
%IMPORTFILE 将文本文件中的数值数据作为列矢量导入。
%   [TRIAL,SUBJECT,COLOR,NAME,STIMULUS,STARTTIMEMS,ENDTIMEMS,TRIGGERLINESTARTMS,TRIGGERLINEDURATIONMS,TRIGGERLINEENDMS,NUMBER,PORTSTATUS]
%   = IMPORTFILE(FILENAME) 读取文本文件 FILENAME 中默认选定范围的数据。
%
%   [TRIAL,SUBJECT,COLOR,NAME,STIMULUS,STARTTIMEMS,ENDTIMEMS,TRIGGERLINESTARTMS,TRIGGERLINEDURATIONMS,TRIGGERLINEENDMS,NUMBER,PORTSTATUS]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) 读取文本文件 FILENAME 的 STARTROW 行到
%   ENDROW 行中的数据。
%
% Example:
%   [Trial,Subject,Color,Name,Stimulus,StartTimems,EndTimems,TriggerLineStartms,TriggerLineDurationms,TriggerLineEndms,Number,PortStatus] = importfile('p01-mark.txt',2, 3);
%
%    另请参阅 TEXTSCAN。

% 由 MATLAB 自动生成于 2016/08/08 15:20:08

%% 初始化变量。
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% 将数据列作为字符串读取:
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式字符串读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% 关闭文本文件。
fclose(fileID);

%% 将包含数值字符串的列内容转换为数值。
% 将非数值字符串替换为 NaN。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,6,7,8,9,10,11,12]
    % 将输入元胞数组中的字符串转换为数值。已将非数值字符串替换为 NaN。
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % 创建正则表达式以检测并删除非数值前缀和后缀。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % 在非千位位置中检测到逗号。
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 将数值字符串转换为数值。
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% 将数据分割为数值列和元胞列。
rawNumericColumns = raw(:, [1,6,7,8,9,10,11,12]);
rawCellColumns = raw(:, [2,3,4,5]);


%% 将导入的数组分配给列变量名称
Trial_mark = cell2mat(rawNumericColumns(:, 1));
Subject_mark = rawCellColumns(:, 1);
Color_mark = rawCellColumns(:, 2);
Name_mark = rawCellColumns(:, 3);
Stimulus_mark = rawCellColumns(:, 4);
StartTimems = cell2mat(rawNumericColumns(:, 2));
EndTimems = cell2mat(rawNumericColumns(:, 3));
TriggerLineStartms = cell2mat(rawNumericColumns(:, 4));
TriggerLineDurationms = cell2mat(rawNumericColumns(:, 5));
TriggerLineEndms = cell2mat(rawNumericColumns(:, 6));
Number = cell2mat(rawNumericColumns(:, 7));
PortStatus = cell2mat(rawNumericColumns(:, 8));


