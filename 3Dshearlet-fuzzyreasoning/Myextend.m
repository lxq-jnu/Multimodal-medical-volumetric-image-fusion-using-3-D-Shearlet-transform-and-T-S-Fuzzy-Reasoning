function [ B ] = Myextend( A )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(A);
B=ones(m+2,n+2);
B(2:m+1,2:n+1)=A;
end

