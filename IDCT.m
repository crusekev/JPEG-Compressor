function idctImg = IDCT(inputImg)
    % Get size of input image
    [rows, cols]=size(inputImg(:,:,1));
    % Generate zero matrix with same dimensions as input image
    idctImg = zeros(rows,cols,3);          
    % Loop through inputImg matrix
    for i = 0:1: rows-1             
        % Get the top left row idex of the 8x8 that i is in
        qRow = floor(i/8) * 8;
        for j = 0:1:cols-1
            % Get the top left column idex of the 8x8 that j is in
            qCol = floor(j/8) *8;            
            for u = qRow:1:qRow+7
                % if u is at the 0th position within 8x8 => assign sqrt(2)/2
                if mod(u,8) == 0 
                    Cu = sqrt(2)/2;
                else
                    Cu = 1;
                end
                for v = qCol:1:qCol+7
                    % if v is at the 0th position within 8x8 => assign sqrt(2)/2
                    if mod(v,8) == 0
                        Cv = sqrt(2)/2;
                    else 
                        Cv = 1;
                    end
                    const = Cu*Cv/4; 
                    % Calculate IDCT using the given formula, then save to
                    % idctImg matrix
                    idctImg(i+1,j+1,1) = idctImg(i+1,j+1,1) + const*cos((2*mod(i,8)+1)*mod(u,8)*pi/16)*cos((2*mod(j,8)+1)*mod(v,8)*pi/16)*inputImg(u+1,v+1,1);
                    idctImg(i+1,j+1,2) = idctImg(i+1,j+1,2) + const*cos((2*mod(i,8)+1)*mod(u,8)*pi/16)*cos((2*mod(j,8)+1)*mod(v,8)*pi/16)*inputImg(u+1,v+1,2);
                    idctImg(i+1,j+1,3) = idctImg(i+1,j+1,3) + const*cos((2*mod(i,8)+1)*mod(u,8)*pi/16)*cos((2*mod(j,8)+1)*mod(v,8)*pi/16)*inputImg(u+1,v+1,3);
                end
            end                       
        end
    end
end