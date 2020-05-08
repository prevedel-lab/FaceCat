function avg_distance = boot(vidReader, nIter, ...
        laserSwitchOn_idx, laserSwitchOff_idx, pos_crop)
%% Create a random sample distribution by measuring the cosine distance between two randomly selected vecotrs n times

    avg_distance = zeros(nIter, 1);
    parfor i=1:nIter
        range_idcs = laserSwitchOn_idx:laserSwitchOff_idx;
        rand_idcs = range_idcs(randperm(numel(range_idcs), 2));
        tic
        rand_frame1 = read(vidReader, rand_idcs(1));
        rand_frame2 = read(vidReader, rand_idcs(2));
        toc
        tic
        rand_frame1 = grayCrop(rand_frame1, pos_crop);
        rand_frame2 = grayCrop(rand_frame2, pos_crop);
      
        rand_hog_vec1 = extractHOGFeatures(rand_frame1, 'CellSize', [32 32], 'NumBins', 8, ...
                                'BlockSize', [1 1]);
        rand_hog_vec2 = extractHOGFeatures(rand_frame2, 'CellSize', [32 32], 'NumBins', 8, ...
            'BlockSize', [1 1]);
        
        rand_hog_Chunk = [rand_hog_vec1; rand_hog_vec2];
        avg_distance(i) = pdist(rand_hog_Chunk, 'cosine');
        toc
    end
end

