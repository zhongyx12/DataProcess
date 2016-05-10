root = '..\DataProcess\bin\Release\';
label = load([root, 'label_cluster.txt']);
timeSim = load([root, 'clusterTimeSimilarity.txt']);
hashtagSim = load([root, 'clusterHashTagSimilarity.txt']);
nameEntitySim = load([root, 'clusterNameEntitySetSimilarity.txt']);

fid=fopen('AdditionSimple_Spectral.txt','w');
fprintf(fid, 'clusterTimeSimilarity.txt\r\n');
fprintf(fid, 'clusterHashTagSimilarity.txt\r\n');
fprintf(fid, 'clusterNameEntitySetSimilarity.txt\r\n');
fprintf(fid, '\r\n');

nmi_max = 0;
for i = 0.0:0.1:1.0
    for j = 0.0:0.1:1.0-i
        k = 1.0 - i - j;
        A = i * timeSim + j * hashtagSim + k * nameEntitySim;
        A = sparse(A);
        for d = 0:1:0
            % region Spectral Clustering
            A = 1 - A;
            [labelE] = sc(A, 0, 686 + d);
            % endregion Spectral Clustering
            
%             % region Hierarchical Clustering
%             A = 1 - A;
%             N = size(A, 1);
%             B = ones(1, N * (N - 1) / 2);
%             index = 1;
%             for ii = 1:1:N-1
%                 for jj = ii+1:1:N
%                     B(index) = A(jj, ii);
%                     index = index + 1;
%                 end
%             end
%             Z = linkage(B, 'single');
%             labelE = cluster(Z, 'maxclust', 686 + d);
%             % endregion Hierarchical Clustering
            
            nmi_value = nmi(label, labelE);
            if nmi_value > nmi_max
               nmi_max = nmi_value;
               record_i = i;
               record_j = j;
               record_k = k;
               record_K = 686 + d;
            end
            fprintf(fid, '%.1f %.1f %.1f %d: %f\r\n', i, j, k, 686 + d, nmi_value);
        end
    end
end

fprintf(fid, '\r\n');
fprintf(fid, 'Max NMI:\r\n');
fprintf(fid, '%.1f %.1f %.1f %d: %f\r\n', record_i, record_j, record_k, record_K, nmi_max);
fclose(fid);