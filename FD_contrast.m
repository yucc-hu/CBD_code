load('G_task.mat'); % 加载数据用来计算元1到元2。元2到元1之间的差异。
load('switches_in_sets_resultsR.mat'); % 加载switchIndicesSetA和switchIndicesSetB

num_rows = size(switchIndicesSetA, 1);

% 初始化存储离散系数的数组和t检验结果的数组
discrepancy_coefficients_A = zeros(num_rows, 1000);
discrepancy_coefficients_B = zeros(num_rows, 1000);
T_values = zeros(1000, 1);
p_values = zeros(1000, 1);

% 重复计算100次
for repeat = 1:1000
    for i = 1:num_rows
        % 获取集合A的行号
        rows_to_calculate_A = switchIndicesSetA{i};

        % 检查行数是否足够
        if numel(rows_to_calculate_A) < 2
            discrepancy_coefficients_A(i, repeat) = NaN;
        else
            % 计算相关矩阵和离散系数
            data_to_analyze_A = G_task(rows_to_calculate_A, :);
            correlation_matrix_A = corr(data_to_analyze_A, 'type', 'Pearson');
            lower_triangular_elements_A = tril(correlation_matrix_A, -1);
            lower_triangular_elements_A = lower_triangular_elements_A(:);
            lower_triangular_elements_A = lower_triangular_elements_A(lower_triangular_elements_A ~= 0);
            discrepancy_coefficients_A(i, repeat) = std(lower_triangular_elements_A);
        end

        % 从集合B随机选择与A相同数量的行
        num_rows_to_select = numel(rows_to_calculate_A);
        all_rows_B = 1:size(G_task, 1);
        rows_to_calculate_B = datasample(all_rows_B, num_rows_to_select, 'Replace', false);

        % 检查行数是否足够
        if num_rows_to_select < 2
            discrepancy_coefficients_B(i, repeat) = NaN;
        else
            % 计算相关矩阵和离散系数
            data_to_analyze_B = G_task(rows_to_calculate_B, :);
            correlation_matrix_B = corr(data_to_analyze_B, 'type', 'Pearson');
            lower_triangular_elements_B = tril(correlation_matrix_B, -1);
            lower_triangular_elements_B = lower_triangular_elements_B(:);
            lower_triangular_elements_B = lower_triangular_elements_B(lower_triangular_elements_B ~= 0);
            discrepancy_coefficients_B(i, repeat) = std(lower_triangular_elements_B);
        end
    end

    % 进行配对样本t检验，忽略NaN值
    [T_values(repeat), p_values(repeat)] = ttest(discrepancy_coefficients_A(:, repeat), discrepancy_coefficients_B(:, repeat));
end

% 保存结果
save('discrepancy_coefficients_A.mat', 'discrepancy_coefficients_A');
save('discrepancy_coefficients_B.mat', 'discrepancy_coefficients_B');
save('T_values_and_p_values.mat', 'T_values', 'p_values');
