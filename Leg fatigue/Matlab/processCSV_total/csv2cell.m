function bigCell = csv2cell(fid)

% Note: save a big csv file into a cell (in the current Matlab workspace)
% fid = fopen([Trial_path '\' filename], 'rt');
    
   % obatin the data length first
   numlines = 0;
   while true
      if ~ischar(fgets(fid)); break; end    %end of file 
     numlines = numlines + 1;
   end
   % note: the file position indicator now is at the END of file
   
   % create a cell for the csv raw data
   bigCell=cell(numlines,1); % allocate cell space first

   frewind(fid); % move the file position indicator back to the starting point
   for rowCnt=1:numlines
       row0= fgetl(fid);
       row_splited=regexp(row0, ',', 'split');  %split into columns (in cell)
       bigCell(rowCnt,1:length(row_splited))=row_splited;
   end
            
      
 end