function [outputMatrix] = reshapeMatrix(inputMatrix, outputSize)

inputDim = size(inputMatrix);
outputMatrix = zeros(outputSize(1), outputSize(2));

k = 1;

for i = 1:outputSize(2)
    for j = 1:outputSize(1)
        outputMatrix(j, i) = inputMatrix(k);
        k = k+1;
    end
end