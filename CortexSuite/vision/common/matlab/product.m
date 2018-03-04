function [matrixOut] = product(matrixIn, direction)

% Initialize matrices
inputDim = size(matrixIn);

% For input matrix (m,n), we need to multiply horizontally if output matrix
%is (m). Else, we multiply vertically.

%if direction is 1, we multiply vertically.
if direction == 1
    matrixOut = zeros(1, inputDim(2));     %initialize the output matrix
    for cols = 1:inputDim(2)
        val = 1;
        for rows = 1:inputDim(1)
            val = matrixIn(rows, cols) * val;
        end
        matrixOut(cols) = val;
    end

%  else multiply horizontally
else
    matrixOut = zeros(inputDim(1), 1);     %initialize the output matrix
    for rows = 1:inputDim(1)
        val = 1;
        for cols = 1:inputDim(2)
            val = matrixIn(rows, cols) * val;
        end
        matrixOut(rows) = val;
    end
end