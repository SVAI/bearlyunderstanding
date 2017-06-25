% Import training data (from MHCflurry database)
[num,text,alldata] = xlsread('curated_training_data.csv','A1:F241553');
seqs = alldata(2:end,2);
y = alldata(2:end,3);

% Define accumulation variables
notchosen = zeros(length(seqs),1);
inputs = zeros(length(seqs),20*9);

% Translate sequence to binary array
for i = 1:length(seqs)
    if length(seqs{i}) == 9
            inputs(i,:) = expandToArray(seqs{i});
        notchosen(i) = 0;
    else
        notchosen(i) = 1;
    end
end

% Populate output matrix
endMatrix = cell(length(seqs),183);
endMatrix(:,1) = text(2:end,1);
endMatrix(:,2:181) = num2cell(inputs);
endMatrix(:,182) = num2cell(zeros(length(seqs),1));
endMatrix(:,183) = num2cell(num(1:end));
endMatrix(notchosen==1,:) = [];

% save files (too big for one file)
firstqexcel = endMatrix(1:50000,:);
secondqexcel = endMatrix(50001:100000,:);
thirdqexcel = endMatrix(100001:150000,:);
fourthqexcel = endMatrix(150001:end,:);
xlswrite('firstqexcel.xlsx',firstq)
xlswrite('secondqexcel.xlsx',secondqexcel)
xlswrite('thirdqexcel.xlsx',thirdqexcel)
xlswrite('fourthqexcel.xlsx',fourthqexcel)