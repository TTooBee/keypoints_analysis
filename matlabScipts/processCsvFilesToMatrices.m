function matrices = processCsvFilesToMatrices(folderPath)
    % 'result_'로 시작하는 모든 CSV 파일 목록을 가져옵니다.
    csvFiles = dir(fullfile(folderPath, 'result_*.csv'));
    
    % 파일 이름이 'result_' 뒤에 숫자를 포함하는지 검증하고 필터링
    filteredFiles = csvFiles(arrayfun(@(x) ~isempty(regexp(x.name, '^result_\d+\.csv$', 'once')), csvFiles));
    
    % CSV 파일 개수만큼의 셀 배열을 초기화합니다.
    matrices = cell(1, length(filteredFiles));
    
    % 필터링된 CSV 파일에 대해 반복합니다.
    for k = 1:length(filteredFiles)
        % 현재 CSV 파일의 전체 경로를 구성합니다.
        fullFileName = fullfile(filteredFiles(k).folder, filteredFiles(k).name);
        
        % CSV 파일 이름을 출력합니다.
        fprintf('Reading %s\n', fullFileName);
        
        % CSV 파일을 읽어들여 행렬로 변환합니다.
        currentMatrix = readmatrix(fullFileName);
        
        % 읽어온 행렬을 셀 배열에 저장합니다.
        matrices{k} = currentMatrix;
    end
end