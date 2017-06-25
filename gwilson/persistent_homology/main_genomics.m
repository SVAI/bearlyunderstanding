%% main_genomics

%% Setup
%add Brain Connectivity Toolbox, Fieldtrip
path(path,'C:\Users\Ekpyrotic\Documents\MATLAB\Math 191\brain_connectivity');
path(path,'C:\Users\Ekpyrotic\Documents\MATLAB\Math 191\BCT\2017_01_15_BCT');
path(path,'C:\Users\Ekpyrotic\Documents\MATLAB\fieldtrip-20170614');
path(path,'C:\Users\Ekpyrotic\Documents\Tensorflow stuff\binding affinity predictor\crystal structures');

load_javaplex;    % must be called every session; have to run script manually (??) will work fine after
api.Plex4.createExplicitSimplexStream() %will return shit if javaplex is working

%% Preprocessing

%Depression analysis
crystaldat{1} = csvread('HLA_A2_1_dist.csv');
crystaldat{2} = csvread('HLA_B5_801_dist.csv');
crystaldat{3} = csvread('HLA_B5_701_dist.csv');

% one = gpuArray(csvread('HLA_A2_1_dist.csv'));
% two = gpuArray(csvread('HLA_B5_801_dist.csv'));
% three = gpuArray(csvread('HLA_B5_701_dist.csv'));

subplot(1,2,1)
figure(1)
imagesc(squeeze(mean(controls, 1)), [0, 1])
colormap jet
subplot(1,2,2)
imagesc(squeeze(mean(affected,1)), [0, 1])
colormap jet
figure(3)
imagesc(squeeze(mean(controls, 1)) - squeeze(mean(affected,1)))


%% Vietoris-Rips Complex --> Bottleneck distances matrix ~~ oh fuq its lit

num_samples   = length(crystaldat);
num_landmark_points  = 300;
max_dimension        = 1;             %capture 0,1 homology groups
max_filtration_value = 1;             %max distance
num_divisions        = 300;           %300 nested simplicial complexes (adjust parameter by 1/25 each time)
intervals = cell(num_samples,1); %store persistence diagram for each image 
persistence = api.Plex4.getModularSimplicialAlgorithm(max_dimension, 2);

%datacloud = cmdscale(input,3);
%calculate persistence diagrams
maxval = [];
for i = 1:length(crystaldat)
    maxval(i) = max(max(crystaldat{i}));
end
maxval = max(maxval);

for i = 1:num_samples
%     if i == 1
%        corrmatrix = one;
%     elseif i == 2
%        corrmatrix = two;
%     else
%        corrmatrix = three; 
%     end
%     
    corrmatrix = crystaldat{i};      %normalize
    %normA     = corrmatrix - min(corrmatrix(:));
    normA      = corrmatrix ./ maxval;
    
    input       = normA;
    m_space     = metric.impl.ExplicitMetricSpace(input);
    max_filtration_value = 1;
    
    % create a lazy witness stream
    landmark_selector = api.Plex4.createMaxMinSelector(m_space, num_landmark_points);
    %stream = streams.impl.LazyWitnessStream(landmark_selector.getUnderlyingMetricSpace(), landmark_selector, max_dimension, max_filtration_value, 1, num_divisions);
    %stream.finalizeStream();
    %create Vietoris-Rips stream 
    %stream = api.Plex4.createVietorisRipsStream(m_space, max_dimension, max_filtration_value,  num_divisions);
    stream = api.Plex4.createVietorisRipsStream(landmark_selector, max_dimension, max_filtration_value,  num_divisions);
    stream.finalizeStream();
    intervals{i} = persistence.computeIntervals(stream);
end

%Display Persistence Barcodes
figure(1)
options.filename = 'Persistence Diagram';
options.max_filtration_value = max_filtration_value;
options.max_dimension = max_dimension;
plot_barcodes(intervals{1}, options)

distancematrix = computeBottleneckDistances(intervals)

%% optional: distance matrix computation
%distancematrix = computeBottleneckDistances(intervals);
%import edu.stanford.math.plex4.visualization.*
%render_onscreen(stream, [1,2,3,4])

%% Organize Barcodes
%ignore infinite values (all will have one)
subjbarcodes     = zeros(num_samples, num_divisions);

for i = 1:num_samples
    %store in vector format:
    endpoints{i,:} = homology.barcodes.BarcodeUtility.getEndpoints(intervals{i},0,true);
    values = sort(endpoints{i,1}(:,2));
    %store in matrix format:
    if(length(endpoints{i,1} ~= num_divisions))
        k = zeros(num_divisions -length(endpoints{i,1}),2);
        endpoints{i,1} = [endpoints{i,1}; k];
    end
    subjbarcodes(i,:) = sort(endpoints{i,1}(:,2))';
end
%% Generate "# connected components as function of time" charts 
barcodeplots = zeros(num_subjects, num_divisions);
for i = 1:num_subjects
    for j = 1:num_divisions
        stepsize = (j-1)/300;
        barcodeplots(i,j) = length(find(subjbarcodes(i,:) <= stepsize));
    end
end

rh_plotsd(linspace(0,1,300), barcodeplots(1:num_controls,:),'b')
rh_plotsd(linspace(0,1,300), barcodeplots(num_controls+1:end,:),'r')

%% Persistence Landscape Approach
%navigate to persistence-landscape-wrapper-master in math 191 folder 
%run build_functions.m in lib folder

cd ../Persistent-landscape-Wrapper-master/lib
build_functions;

%now convert our 0-barcode information into persistence landscapes 

pl    = cell(1,num_samples);
for i = 1:num_samples
    barcode = subjbarcodes(i,find(subjbarcodes(i,:) ~= 0)); 
    barcode = [zeros(1, length(barcode)); barcode]';
    pl{i}   = barcodeToLandscape(barcode);
end

%calculate distance from group means for all subjects

%------------sanity check + for comparison with persistence diagrams--------
distances = zeros(num_samples, num_samples);
for i = 1:num_samples
    for j = 1:num_samples
        if j >= i
            distances(i,j) = landscapeBottleneckDistance(pl{i},pl{j});
        else 
            distances(i,j) = distances(j,i);
        end
    end
end
csvwrite('HLAdistmatrix.csv',distances)
% 3d scatter plot for MDS = 3
scatter3(datacloud(:,1),datacloud(:,2),datacloud(:,3))
scatter3(datacloud(1:18,1),datacloud(1:18,2),datacloud(1:18,3),'r','filled')
hold on
scatter3(datacloud(18:end,1),datacloud(18:end,2),datacloud(18:end,3),'b','filled')
predictormatrix = [datacloud, groupvec];
%------------------------------------------

centroiddist = zeros(2, num_subjects);
predictions  = zeros(size(num_subjects));
%(1,:) = distance to control avg; (2,:) = distance to MDD average 
%---------Calculate averages for groups with LOOCV approach-----
for i = 1:num_subjects
%     if i <= num_controls
%         indices_C = [1:i-1, i+1:num_controls];
%         indices_D = [num_controls+1:num_subjects];
%     else
%         indices_C = [1:num_controls];
%         indices_D = [num_controls+1:i-1, i+1:num_subjects];
%     end
%     disp(size(indices_C))
%     disp(size(indices_D))
%     mean_control   = landscapeAverage({pl{indices_C}});
%     mean_affected  = landscapeAverage({pl{indices_D}});
%     centroiddist(1,i) = landscapeBottleneckDistance(pl{i}, mean_control);
%     centroiddist(2,i) = landscapeBottleneckDistance(pl{i}, mean_affected);
    %----alternative: find average distance--------------------
    dist_C = 0; dist_D = 0;
    for j = 1:num_subjects
       if j ~= i
           if j <= num_controls
                dist_C = [dist_C, landscapeBottleneckDistance(pl{i},pl{j})];
           else
                dist_D = [dist_D, landscapeBottleneckDistance(pl{i},pl{j})];
           end
       end
    end
    dist_C(dist_C == 0) = [];
    dist_D(dist_D == 0) = [];
    centroiddist(1,i) = mean(dist_C);
    centroiddist(2,i) = mean(dist_D);
    [val pos]      = min(centroiddist(:,i));
    predictions(i) = pos;
end
predictormatrix = [centroiddist; groupvec'];
%predictormatrix = [datacloud, groupvec];

%permutation test on MDS based PL and PD classifiers
PDacc = [84.8,84.8,81.8,
         84.8,87.9,87.9,
         63.6,63.6,63.6,
         66.7,66.7,63.6,
         48.5,57.6,60.6,
         66.7,63.6,72.7];
PLacc = [84.8,84.8,81.8-3,
         84.8,87.9-3.1,87.9,
         63.6,63.6,63.6,
         66.7,66.7,63.6+3,
         48.5-3,57.6,60.6,
         66.7,63.6,66.7];
PDacc = reshape(PDacc, 1, []); PLacc = reshape(PLacc, 1, []);
p = PermutationTest([PDacc, PLacc]', [zeros(1,18), ones(1,18)]', 5000, 0.05)





%% Comparison with other graph metrics
binarizedgraphs = zeros(size(inputdata));

%first set diagonal to 0 --> formatting for BCT
for i = 1:subj
   for j = 1:channels
      inputdata(i,j,j) = 0; 
   end
end
%------------------------------
% Following SVM paper procedure --> binarize matrices to 25%

for i = 1:subj
    corrmatrix = weight_conversion(squeeze(inputdata(i,:,:)),'normalize'); %remove between subject differences
    corrmatrix = threshold_proportional(corrmatrix, 0.25);
    binarizedgraphs(i,:,:) = weight_conversion(corrmatrix, 'binarize');
end
%----------------------------------------------------
%note: for alternative analysis do NOT run above block 

%now calculate transitivity, char path length
[transitivity_dat, charpathlength_dat, smallworldness, flow] = deal(zeros(subj,1));

for i = 1:subj
   transitivity_dat(i)   = transitivity_bu(squeeze(binarizedgraphs(i,:,:)));
   shortestpathmatrix    = distance_bin(squeeze(binarizedgraphs(i,:,:)));
   charpathlength_dat(i) = mean(mean(shortestpathmatrix(shortestpathmatrix ~= inf)));
   smallworldness(i)     = transitivity_dat(i)/charpathlength_dat(i);
   [ind flow(i) total]   = flow_coef_bd(squeeze(binarizedgraphs(i,:,:)));
end

predictormatrix = [datacloud, smallworldness, groupvec];







