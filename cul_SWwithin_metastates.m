% 加载数据  
load('V_task.mat', 'vpath');

% 定义数据集
setA = [5, 6, 8, 9, 10, 11];
setB = [1, 2, 3, 4, 7, 12];

% 切分数据
numParts = 842;
rowsPerPart = 756;  % 每份756行
switchesInSetA = zeros(numParts, 1);
switchesInSetB = zeros(numParts, 1);

for i = 1:numParts
    % 获取当前部分的数据
    startRow = (i - 1) * rowsPerPart + 1;
    endRow = startRow + rowsPerPart - 1;
    currentData = vpath(startRow:endRow);

    % 初始化计数器和前一个元素
    prevElement = currentData(1);
    switchesInCurrentSetA = 0;
    switchesInCurrentSetB = 0;

    % 计算数据集A和数据集B内部数字间转换的次数（不包括相同数字）
    for j = 2:length(currentData)
        currentElement = currentData(j);
        
        % 在数据集A内部的数字间转换（不包括相同数字）
        if ismember(prevElement, setA) && ismember(currentElement, setA) && prevElement ~= currentElement
            switchesInCurrentSetA = switchesInCurrentSetA + 1;
        end
        
        % 在数据集B内部的数字间转换（不包括相同数字）
        if ismember(prevElement, setB) && ismember(currentElement, setB) && prevElement ~= currentElement
            switchesInCurrentSetB = switchesInCurrentSetB + 1;
        end
        
        % 更新前一个元素
        prevElement = currentElement;
    end
    
    % 将每份内部转换次数保存到相应的数组中
    switchesInSetA(i) = switchesInCurrentSetA;
    switchesInSetB(i) = switchesInCurrentSetB;
end

% 将结果保存到文件
save('switches_in_sets_results.mat', 'switchesInSetA', 'switchesInSetB');

