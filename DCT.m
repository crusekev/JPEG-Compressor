function dctImg = DCT(inputImg)
    % Get size of input image
    [unpaddedRows, unpaddedCols]=size(inputImg(:,:,1));
    % Pad rows and cols so they are multiple of 8
    rowPad = mod((8 - mod(unpaddedRows, 8)), 8);
    colPad = mod((8 - mod(unpaddedCols, 8)), 8);
    
    paddedImg = padarray(inputImg, [rowPad colPad], 'replicate', 'post');

    % Generate zero matrix with same dimensions as input image
    [rows, cols] = size(paddedImg(:,:,1));
    dctImg = zeros(rows,cols,3);
    temp = zeros(rows,cols,3);

    % Loop for dctImg matrix
    for u = 0:1:rows-1  
        % Get the top left row index of the 8x8 that u is in
        qRow = floor(u/8) * 8;
        % if u is at the 0th position within 8x8 => assign sqrt(2)/2
        if mod(u,8) == 0 
            Cu = sqrt(2)/2;
        else
            Cu = 1;
        end
        for v = 0:1:cols-1
            % Get the top left column idex of the 8x8 that v is in
            qCol = floor(v/8) *8;
            % if v is at the 0th position within 8x8 => assign sqrt(2)/2
            if mod(v,8) == 0
                Cv = sqrt(2)/2;
            else 
                Cv = 1;
            end
            % Loop through inputImg matrix
            for i = qRow:qRow+7
                for j = qCol:qCol+7
                    % Save results to a temporary matrix (use mod to get
                    % the respective postion within 8x8 block)
                    temp(i+1,j+1,1) = cos((2*mod(i,8)+1)*mod(u,8)*pi/16)*cos((2*mod(j,8)+1)*mod(v,8)*pi/16)*double(paddedImg(i+1,j+1,1));
                    temp(i+1,j+1,2) = cos((2*mod(i,8)+1)*mod(u,8)*pi/16)*cos((2*mod(j,8)+1)*mod(v,8)*pi/16)*double(paddedImg(i+1,j+1,2));
                    temp(i+1,j+1,3) = cos((2*mod(i,8)+1)*mod(u,8)*pi/16)*cos((2*mod(j,8)+1)*mod(v,8)*pi/16)*double(paddedImg(i+1,j+1,3));
                end
            end
            % Calculate value and assign result to dctImg
            const = Cu*Cv/4;
            dctImg(u+1,v+1,:) = sum(sum(temp(qRow+1:qRow+8, qCol+1:qCol+8,:))).*const;
        end
    end    
end