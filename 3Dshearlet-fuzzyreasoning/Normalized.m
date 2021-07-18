function [normalized_matrix]=Normalized(matrix)
% Computes the normalized form of matrix
% ������ľ����ͼ����й�һ������
% Input: matrix, denotes an image - ����ͼ�����
% Output: normalized_matrix,normalized form of matrix
%    cmin is the smallest element in matrix - ������Сֵ
%    cmax is the largest element in matrix - �������ֵ

% Get absolute value of matrix
input_matrix=abs(matrix);
Max_input=max(input_matrix(:));
Min_input=min(input_matrix(:));

% min_matrix=ones(size(input_matrix)).*Min_input;  %��������¾书�ܵ�ͬ
% normalized_matrix=(input_matrix-min_matrix)./(Max_input-Min_input+eps);
normalized_matrix=(input_matrix-Min_input)./(Max_input-Min_input+eps);
cmin=Min_input;
cmax=Max_input;