% 加载数据
load('V_task.mat', 'vpath');

% 定义数据集
setA = [5, 6, 8, 9, 10, 11];
setB = [1, 2, 3, 4, 7, 12];

% 切分数据
numParts = 842;
rowsPerPart = 756;  % 每份756行
totalSwitches = zeros(numParts, 1);
switchesAtoB = zeros(numParts, 1);
switchesBtoA = zeros(numParts, 1);

for i = 1:numParts
    % 获取当前部分的数据
    startRow = (i - 1) * rowsPerPart + 1;
    endRow = startRow + rowsPerPart - 1;
    currentData = vpath(startRow:endRow);

    % 初始化计数器和前一个元素
    prevElement = currentData(1);
    partSwitchesAtoB = 0;
    partSwitchesBtoA = 0;

    % 计算特定集合间的切换次数，包括前后顺序的切换
    for j = 2:length(currentData)
        currentElement = currentData(j);
        
        % 从集合A到B的切换
        if ismember(prevElement, setA) && ismember(currentElement, setB)
            partSwitchesAtoB = partSwitchesAtoB + 1;
        end
        
        % 从集合B到A的切换
        if ismember(prevElement, setB) && ismember(currentElement, setA)
            partSwitchesBtoA = partSwitchesBtoA + 1;
        end
        
        % 更新前一个元素
        prevElement = currentElement;
    end
    
    % 将每份的切换次数保存到相应的数组中
    totalSwitches(i) = sum(diff(currentData) ~= 0);
    switchesAtoB(i) = partSwitchesAtoB;
    switchesBtoA(i) = partSwitchesBtoA;
end

% 将结果保存到文件
save('switches_results.mat', 'totalSwitches', 'switchesAtoB', 'switchesBtoA');


