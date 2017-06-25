function [outputArray] = expandToArray(inputString)
    % Takes string array of one-letter protein sequence as input, outputs
    % binary array representing sequence
    stringlen = length(inputString);
    outputArray = zeros(1,stringlen);
    for i = 1:stringlen
        if inputString(i) == 'A'
            outputArray((20*(i-1)+1):20*i) = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'C'
            outputArray((20*(i-1)+1):20*i) = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'D'
            outputArray((20*(i-1)+1):20*i) = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'E'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'F'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'G'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'H'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'I'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'K'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'L'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'M'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'N'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0];
        elseif inputString(i) == 'P'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
        elseif inputString(i) == 'Q'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0];
        elseif inputString(i) == 'R'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0];
        elseif inputString(i) == 'S'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0];
        elseif inputString(i) == 'T'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0];
        elseif inputString(i) == 'V'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0];
        elseif inputString(i) == 'W'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0];
        elseif inputString(i) == 'Y'
            outputArray((20*(i-1)+1):20*i) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
        end
    end


end
