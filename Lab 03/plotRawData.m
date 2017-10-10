function dados = plotRawData(arquivoDados, colunas)
%function dados = plotRawData(arquivoDados, colunas)
%
% Rotina para plotar gr�ficos a partir de arquivos textos exportados pelo
% software dos equipamentos ECP (Menu Data / Export Raw Data').
%
% Entradas: 
%           arquivoDados: Nome do arquivo exportado pelo software ECP.
%           colunas:      Esse par�metro � opcional. Caso n�o seja 
%                         informado, o programa ir� identificar todos dados 
%                         dispon�veis (colunas do arquivo de entrada) para 
%                         desenho e o usu�rio poder� escolher qual(is) 
%                         coluna(s) deseja plotar. Caso o usu�rio j� saiba 
%                         qual(is) coluna(s) quer plotar, as mesmas poder�o
%                         ser informadas previamente por meio dessa 
%                         vari�vel (formato vetor).
%
% sa�da: 
%         dados: caso essa vari�vel de sa�da seja utilizada, o programa
%                ir� apenas extrair os dados do arquivo de entrada e
%                armazen�-los nessa vari�vel.

% Autor: ricfow@dt.fee.unicamp.br
% Data: 16.04.2013
% �ltima atualiza��o: 07.05.2013 (introdu��o de legendas no gr�fico)
%
% Exemplo:
% % Seja o arquivo de entrada 'teste.txt'.
% % Para saber quais dados (colunas) est�o dispon�veis:
% plotRawData('teste.txt');
% % Caso queira plotar as primeira e segunda coluna de dados:
% plotRawData('teste.txt',[1 2]);


output = ExtractData(arquivoDados);
assignin('base', 'aberta', output.data);
fields = ExtractFields(output.firstLine);
if nargout == 1
    dados.tempo = output.data(:,2);
    dados.var = output.data(:,3:end);
    dados.nomeVar = {};
    for i=1:size(fields,2)
        if strcmp(fields{i},'Time ') == 0 &&  strcmp(fields{i},'Sample ') == 0
            dados.nomeVar{size(dados.nomeVar,2)+1} =  fields{i};
        end
    end
    return;
end

if nargin == 1
    fprintf('Dados disponiveis para plotar:\n');
    for i=1:size(fields,2)
        if strcmp(fields{i},'Time ') == 0 &&  strcmp(fields{i},'Sample ') == 0
            fprintf('\t %s (coluna %d)\n',fields{i},i-2);
        end
    end
    fprintf('\n');
    colunas = input('Escolha a(s) coluna(s) para plotar: ');        
end
if exist('colunas')
    if isnumeric(colunas)
        f = figure(1);
        plot(output.data(:,2),output.data(:,colunas+2));
        %pos = get(f,'Position');
        %pos(2) = 300;
        %pos(3) = 640;
        %pos(4) = 480;
        %set(f,'Position',pos);        
        grid on;
        xlabel tempo;
        if size(colunas,2) == 1
            ylabel(fields{colunas(1,1)+2});
        else
            legend(fields{1,colunas+2})
        end
    else
        fprintf('Colunas inv�lidas !\n');
    end
end

%__________________________________________________________________________
function fields = ExtractFields(firstLine)

field = [];
space = 0;
nf = 1;
willClose = 0;
for i=1:size(firstLine,2)
    if int32(firstLine(1,i)) == 32
        space = space + 1;
        if space >= 2
            willClose = 1;
        else
            if ~isempty(field)
                field = [field ' '];
            end
        end
    else        
        space = 0;
        if int32(firstLine(1,i)) ~= 10 &  int32(firstLine(1,i)) ~= 13
            if willClose
                fields{nf} = field;
                nf = nf + 1;
                field = firstLine(1,i);
                willClose = 0;
            else
                field = [field firstLine(1,i)];
            end
        end
    end    
end
fields{nf} = field;


%__________________________________________________________________________
function output = ExtractData(fileName)

fileIN = fopen(fileName,'r');
line = fgets(fileIN);
output.firstLine = line;
fgets(fileIN);
line = fgets(fileIN);
output.data = [];
while line ~= -1    
    if size(line,2) > 1
        if strcmp(line(1,1),'[') == 1
            line = line(1,2:end);
        end
        if strcmp(line(1,end-2),']') == 1
            line = strcat(line(1,1:end-3),';');
        end
        x = str2num(line);
        output.data = [output.data;x];
    end
    line = fgets(fileIN);
end
fclose(fileIN);

