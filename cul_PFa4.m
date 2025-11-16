% 加载G_task4和V_task4数据
load('G_task4.mat');
load('V_task4.mat');

% 获取主题数量和条件数量
numSubjects = 842;
numConditions = 12;
numColumns = 12;

% 将G_task4数据reshape成842个180×12的cell数组
dataCellG = cell(numSubjects, 1);
for i = 1:numSubjects
    startIdx = (i - 1) * 180 + 1;
    endIdx = i * 180;
    dataCellG{i} = G_task4(startIdx:endIdx, :);
end

% 将V_task4数据reshape成842个180×12的cell数组
dataCellV = cell(numSubjects, 1);
for i = 1:numSubjects
    startIdx = (i - 1) * 180 + 1;
    endIdx = i * 180;
    dataCellV{i} = V_task4(startIdx:endIdx, :);
end

% 初始化存储结果的cell数组
discrepancyCoefficients = cell(numConditions, 1);

% 循环处理每个条件
for i = 1:numConditions
    % 初始化矩阵来存储每个条件下每个被试的每列数据的离散系数
    conditionDiscrepancies = zeros(numSubjects, numColumns);
    
    % 针对每个主题
    for j = 1:numSubjects
        stateIdx = dataCellV{j}(:, 1) == i;
        
        if any(stateIdx)
            dataG = dataCellG{j}(stateIdx, :);
            
            % 从匹配到的行中仅抽取前20个值进行计算
            dataG = dataG(1:min(20, size(dataG, 1)), :); % 确保不超过匹配到的行数
            
            % 计算每列的均值和标准差
            meanData = mean(dataG);
            stdData = std(dataG);
            
            % 计算每列的离散系数
            conditionDiscrepancies(j, :) = stdData ./ meanData;
        else
            % 如果没有匹配的数据或匹配到的行不够20个，设置离散系数为NaN
            conditionDiscrepancies(j, :) = NaN(1, numColumns);
        end
    end
    
    % 将每个条件的结果存储在cell数组中
    discrepancyCoefficients{i} = conditionDiscrepancies;
    
    % 保存每个条件的结果到.mat文件
    save(['condition_' num2str(i) '_discrepancyCoefficientsbart.mat'], 'conditionDiscrepancies');
end




