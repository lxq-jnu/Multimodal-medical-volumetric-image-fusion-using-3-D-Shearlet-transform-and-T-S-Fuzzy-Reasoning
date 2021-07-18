function [normalized_matrix]=Normalized(matrix)
% Computes the normalized form of matrix
% 对输入的矩阵或图像进行归一化处理
% Input: matrix, denotes an image - 输入图像矩阵
% Output: normalized_matrix,normalized form of matrix
%    cmin is the smallest element in matrix - 矩阵最小值
%    cmax is the largest element in matrix - 矩阵最大值

% Get absolute value of matrix
input_matrix=abs(matrix);
Max_input=max(input_matrix(:));
Min_input=min(input_matrix(:));

% min_matrix=ones(size(input_matrix)).*Min_input;  %这两句和下句功能等同
% normalized_matrix=(input_matrix-min_matrix)./(Max_input-Min_input+eps);
normalized_matrix=(input_matrix-Min_input)./(Max_input-Min_input+eps);
cmin=Min_input;
cmax=Max_input;