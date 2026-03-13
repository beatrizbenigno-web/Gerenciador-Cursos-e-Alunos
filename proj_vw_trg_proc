create table curso (
	codigo VARCHAR(20) not null,
	nome VARCHAR(150) not null,
	carga_horaria INT not null,
	
	constraint pk_curso primary key (codigo),
	constraint ck_carga_horaria check (carga_horaria > 0)
	-- usamos constraint para que a chave seja gerada com o nome que atribuimos a ela. 
	-- assim futuramente caso ocorra algum erro saberei onde foi.
	-- o check tem a função de garantir que a carga horária seja sempre acima de 0.
	
);

create table aluno (
	matricula VARCHAR(20) not null,
	nome VARCHAR(150) not null,
	email VARCHAR(150),
	status_academico VARCHAR(50) default 'ATIVO',
	-- o DEFAULT tem a função de atribuir automaticamente o status do aluno, caso niguém escreva. 
	-- então já fica como ATIVO.
	
	constraint pk_aluno primary key (matricula),
	constraint uq_aluno_email unique (email),
	-- o UNIQUE tem a função de garantir que o email seja único, para evitar que haja dois alunos com o mesmo email, o que poderia causar confusão.
	constraint ck_status_aluno check (status_academico IN ('ATIVO', 'INATIVO', 'TRANCADO', 'FORMADO'))
	-- ATUALIZEI o código e defini que os status do aluno no sistema serão esses, para niguém escrever errado.
);

create table turma (
	id_turma INT generated always as identity,
	cod_curso VARCHAR (20) not null,
	periodo VARCHAR(10) not null,
	dias_horarios json not null,
	vagas_totais int not null default 0,
	-- o JSON tem a função de armazenar os dias e horários das aulas, para que seja possível ter uma estrutura mais flexível e fácil de consultar.
	-- o DEFAULT tem a função de atribuir automaticamente o número de vagas, caso niguém escreva.
	
	constraint pk_turma primary key (id_turma),
	constraint ck_vagas check (vagas_totais >= 0),
	-- aqui o constraint delimita que as vagas totais tem que ser maior ou igual a zero.
	
	constraint fk_turma_curso foreign key (cod_curso)
		references curso (codigo)
		on update cascade 
		on delete restrict
		-- o update cascade e o delete restrict tem a função de garantir a integridade referencial, 
		-- ou seja, se um curso for atualizado ou deletado, as turmas relacionadas a ele também serão atualizadas ou não poderão ser deletadas, respectivamente.
);

create table matricula (
	id_matricula INT generated always as identity,
	id_turma INT not null,
	mat_aluno VARCHAR (20) not null,
	nota_final DECIMAL(5, 2) default 0.00,
	frequencia INT default 0,
	situacao VARCHAR(20) default 'CURSANDO',
	-- o DECIMAL tem a função de armazenar a nota final com duas casas decimais, para que seja possível ter uma precisão maior nas notas.//
	-- o DEFAULT tem a função de atribuir automaticamente a nota final, frequência e situação,
	-- caso niguém escreva, para que o sistema funcione mesmo que os dados não sejam preenchidos.//
	-- o default da situação é CURSANDO, para que quando o aluno for matriculado ele já fique com esse status, 
	-- e depois possa ser atualizado para APROVADO ou REPROVADO, por exemplo.

	constraint pk_matricula primary key (id_matricula),
	
	-- regras de negócio
	constraint ck_nota_valida check (nota_final >= 0 and nota_final <= 100),
	-- a nota tem que ser entre 0 e 100, então o check garante isso.
	constraint ck_frequencia_valida check (frequencia >= 0 and frequencia <= 100),
	-- para a frequência é que ela tem que ser entre 0 e 100 também.
	constraint uq_aluno_turma unique (id_turma, mat_aluno),
	constraint ck_situacao_valida check (situacao in ('CURSANDO', 'APROVADO', 'REPROVADO', 'TRANCADO')),
	-- para a situação é que ela tem que ser uma dessas opções, para evitar que alguém escreva errado e acabe com dados inconsistentes.
	
	-- chaves estrangeiras
	constraint fk_matricula_turma foreign key (id_turma)
		references turma (id_turma)
		on update cascade
		on delete restrict,
	
	constraint fk_matricula_aluno foreign key (mat_aluno)
		references aluno (matricula)
		on update cascade
		on delete restrict
);

-- CREATE VIEW --
-- a create view é uma consulta pré-definida que pode ser tratada como uma tabela virtual. é como um atalho inteligente.
-- ela é útil para simplificar consultas complexas, melhorar a legibilidade do código e reutilizar consultas frequentes sem precisar reescrevê-las toda vez.

CREATE VIEW vw_relatorio_notas AS
SELECT -- aqui pegamos os campos que queremos mostrar na nossa view, que é um relatório de notas dos alunos.
    a.nome as Aluno,
    c.nome as Curso,
    m.nota_final as Nota,
    m.situacao as Status

    -- a.nome: Para mostrar o nome do aluno.
    -- c.nome: Para mostrar o nome do curso que o aluno fez.
    -- m.nota_final: Para mostrar a nota final do aluno.
    -- m.situacao: Para mostrar se o aluno foi aprovado ou reprovado.

from matricula m -- essa linha indica que a consulta principal está sendo feita na tabela matricula, que contém as informações de matrícula dos alunos.
join aluno a on m.mat_aluno = a.matricula -- JOIN com a tabela aluno para obter o nome do aluno, usando a chave mat_aluno para relacionar as duas tabelas.
join turma t on m.id_turma = t.id_turma -- um JOIN com a tabela turma para obter informações sobre a turma, usando a chave id_turma para relacionar as tabelas.
join curso c on t.cod_curso = c.codigo -- um JOIN com a tabela curso para obter o nome do curso, usando a chave cod_curso para relacionar as tabelas.
order by a.nome;
-- order by a.nome: Para organizar o relatório em ordem alfabética pelo nome do aluno, facilitando a leitura e consulta.

-- A view vw_relatorio_notas é útil para gerar relatórios de desempenho dos alunos, 
-- permitindo análises rápidas sobre quem são os alunos, quais cursos fizeram, suas notas e status de aprovação. 
-- Ela pode ser utilizada por professores e coordenadores para monitorar o progresso dos alunos e identificar áreas que precisam de atenção.


-- CREATE MATERIALIZED VIEW --
-- A create materialized view é semelhante a uma view normal, mas os dados são armazenados fisicamente no banco de dados (como um print).
-- ou seja, ela é uma tabela real que contém os resultados da consulta no momento em que a materialized view é criada ou atualizada.
-- A vantagem da materialized view é que ela pode melhorar o desempenho de consultas complexas, 
-- pois os dados já estão pré-calculados e armazenados, evitando a necessidade de executar a consulta toda vez que a view for acessada. 


CREATE MATERIALIZED VIEW mv_total_alunos_turma AS
SELECT -- aqui os campos que queremos na nossa materialized view, que é o total de alunos por turma.
    t.id_turma,
    c.nome as Nome_Curso,
    t.periodo,

    -- t.id_turma: Para identificar a turma específica.
    -- c.nome: Para saber de qual curso é essa turma.
    -- t.periodo: Para diferenciar turmas do mesmo curso em semestres diferentes.

    COUNT(m.id_matricula) as Total_Alunos
    -- o COUNT(m.id_matricula) é usado para contar quantos alunos estão matriculados em cada turma, 
    --fornecendo uma visão geral da quantidade de alunos por turma.

from curso c
join turma t on c.codigo = t.cod_curso
join matricula m on t.id_turma = m.id_turma
group by t.id_turma, c.nome, t.periodo;
-- o group by t.id_turma, c.nome, t.periodo é necessário para agrupar os resultados por turma, curso e período.

-- A materialized view mv_total_alunos_turma é útil para obter rapidamente o número total de alunos em cada turma,
-- o que pode ajudar na gestão de turmas.

-- OBSERVAÇÃO: Como esta é uma VIEW MATERIALIZADA, 
-- para atualizar os dados após novos INSERTs, é necessário executar:
REFRESH MATERIALIZED VIEW mv_total_alunos_turma;



-- TRIGGERS (BEFORE UPDATE, AFTER INSERT)
-- Os triggers são procedimentos que são automaticamente executados em resposta a certos eventos no banco de dados, como inserções, atualizações ou exclusões.
-- Eles são usados para manter a integridade dos dados, automatizar tarefas e garantir que certas regras de negócios sejam aplicadas consistentemente.

CREATE OR REPLACE FUNCTION fn_ajusta_status()
RETURNS trigger AS $$ 
BEGIN
    -- A função fn_ajusta_status é um gatilho (trigger) que é acionado antes de uma atualização (BEFORE UPDATE) na tabela matricula.
    -- O objetivo dessa função é garantir que o campo status_academico seja sempre armazenado em letras maiúsculas,
    -- independentemente de como o usuário insira os dados. 

    new.status_academico = upper(new.status_academico);
	new.nome = upper(new.nome);
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ajusta_status
before insert or update on aluno -- before insert/update quer dizer que será acionado antes de uma nova linha ser inserida na tabela aluno ou antes de uma linha existente ser atualizada.
for each row -- esse trigger é acionado para cada linha que for inserida ou atualizada na tabela aluno.
execute function fn_ajusta_status();

--

CREATE OR REPLACE FUNCTION fn_atualiza_vagas()
RETURNS trigger AS $$
BEGIN
    -- Essa função é um gatilho (trigger) que é acionado após uma inserção na tabela matricula.
    -- O objetivo dessa função é atualizar automaticamente o número de vagas disponíveis na turma correspondente,
    -- subtraindo 1 do total de vagas totais da turma sempre que um novo aluno for matriculado. 

    update turma
    SET vagas_totais = vagas_totais -1 -- aqui a função subtrai 1 do total de vagas totais da turma.
    where id_turma = new.id_turma; -- aqui a função identifica qual turma deve ser atualizada, usando o id_turma da nova matrícula.

    return new;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_vagas_matricula
after insert on matricula -- after insert quer dizer que será acionado depois que uma nova linha for inserida na tabela matricula, ou seja, depois que um aluno for matriculado.
for each row 
execute function fn_atualiza_vagas();

-- esse create trigger é responsável por chamar a função fn_atualiza_vagas toda vez que uma nova matrícula for inserida, 
-- garantindo que o número de vagas seja atualizado automaticamente.



-- PROCEDURE
-- A PROCEDURE QUE FIZ: Se um aluno trancou o curso ou saiu da faculdade, 
--a procedure vai receber a matrícula do aluno e mudar o status dele para 'INATIVO' automaticamente.

CREATE OR REPLACE PROCEDURE cp_desativa_aluno(p_matricula VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE aluno
    SET status_academico = 'INATIVO'
    WHERE matricula = p_matricula;

    RAISE NOTICE 'Aluno com matrícula % foi desativado.', p_matricula; -- para confirmar que a procedure foi executada com sucesso.

END;
$$;

-- Para executar a procedure, basta usar o comando CALL, passando a matrícula do aluno que deseja desativar:
-- CALL cp_desativa_aluno('A0003'); exemplo de aluno com matricula trancada.


-- DADOS (3 REGISTROS POR TABELA)

insert into curso (codigo, nome, carga_horaria) values
('SQL-01', 'PROJETO DE BANCO DE DADOS', 45),
('DN-02', 'DESENVOLVIMENTO EM NUVEM', 50),
('IHC-03', 'INTERFACE HUMANO COMPUTADOR', 40),
('PI-04', 'PROJETO INTEGRADO', 30);

insert into aluno (matricula, nome, email, status_academico) values
('A0001', 'Beatriz Benigno', 'beatriz@email.com', 'ATIVO'),
('A0002', 'Junior Ferreira', 'juniorferr@email.com', 'ATIVO'),
('A0003', 'Ivanilda Sousa', 'ivasousa@email.com', 'TRANCADO'),
('A0004', 'Eduardo Lima', 'edulima@email.com', 'ATIVO'),
('A0005', 'manu benigno', 'manu@email.com', 'ativo');

insert into turma (cod_curso, periodo, dias_horarios, vagas_totais) values
('SQL-01', '2026.1', '{"seg": "09:00"}', 20),
('DN-02',  '2026.1', '{"ter": "14:00"}', 15),
('IHC-03',  '2026.2', '{"sab": "08:00"}', 30);

insert into matricula (id_turma, mat_aluno, nota_final, frequencia, situacao) values
(1, 'A0001', 95.5, 100, 'APROVADO'),
(1, 'A0002', 45.0, 60, 'REPROVADO'),
(2, 'A0001', 88.0, 90, 'APROVADO'),
(3, 'A0004', 0.0, 0, 'CURSANDO'),
(1, 'A0005', 60.0, 70, 'APROVADO');

-- CONSULTA 1: Relatório de Notas. (INNER JOIN com 3 tabelas)
-- Objetivo: Listar o nome do aluno, o curso que ele fez e sua nota final.
select
    a.nome as Aluno,
    c.nome as Curso,
    m.nota_final as Nota,
    m.situacao as Status
from matricula m
join aluno a on m.mat_aluno = a.matricula
join turma t on m.id_turma = t.id_turma
join curso c on t.cod_curso = c.codigo
order by a.nome;

-- CONSULTA 2: Mostrar apenas os alunos da turma de PROJETO DE BANCO DE DADOS. (JOIN + WHERE)
select
    t.id_turma,
    c.nome as Nome_Curso,
    a.nome as Nome_Aluno
from matricula m
join turma t on m.id_turma = t.id_turma
join curso c on t.cod_curso = c.codigo
join aluno a on m.mat_aluno = a.matricula
where c.codigo = 'SQL-01';

-- CONSULTA 3: Listar emails dos alunos que foram reprovados para enviar aviso.(JOIN + WHERE)
select
    a.nome,
    a.email,
    c.nome as disciplina,
    m.nota_final
from matricula m
join aluno a on m.mat_aluno = a.matricula
join turma t on m.id_turma = t.id_turma
join curso c on t.cod_curso = c.codigo
where m.situacao = 'REPROVADO';

-- CONSULTA 4: Listar todos os cursos e ver quais têm turmas abertas. (LEFT JOIN)
-- (Cursos sem turma aparecerão com NULL no período)

select
    c.nome as Curso,
    t.periodo as Periodo_Turma,
    t.vagas_totais
from curso c
left join turma t on c.codigo = t.cod_curso;

-- CONSULTA 5: Histórico da aluna Beatriz (JOIN + Filtro Específico)
select
    a.nome,
    c.nome as disciplina,
    t.periodo,
    m.nota_final
from matricula m
join aluno a on m.mat_aluno = a.matricula
join turma t on m.id_turma = t.id_turma
join curso c on t.cod_curso = c.codigo
where a.matricula = 'A0001';


-- SELECT * FROM vw_relatorio_notas;


-- para rodar cole o código no DBEAVER, faça a conexão com o PostgreSQL e dê um ALT + X.

