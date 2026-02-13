
create table curso (
	codigo VARCHAR(20) not null,
	nome VARCHAR(150) not null,
	carga_horaria INT not null,
	
	constraint pk_curso primary key (codigo),
	constraint ck_carga_horaria check (carga_horaria > 0)
	-- usamos constraint para que a chave seja gerada com o nome que atribuimos a ela. 
	-- assim futuramente caso ocorra algum erro saberei onde foi.
	-- // o check tem a função de garantir que a carga horária seja sempre acima de 0.
);

create table aluno (
	matricula VARCHAR(20) not null,
	nome VARCHAR(150) not null,
	email VARCHAR(150),
	status_academico VARCHAR(50) default 'ATIVO',
	-- o DEFAULT tem a função de atribuir automaticamente o status do aluno, caso niguém escreva. 
	-- então já fica como ATIVO.
	
	constraint pk_aluno primary key (matricula),
	constraint uq_aluno_email unique (email)
	constraint ck_status_aluno check (status_academico IN ('ATIVO', 'INATIVO', 'TRANCADO', 'FORMADO'))
	-- ATUALIZEI o código e defini que os status do aluno no sistema serão esses, para niguém escrever errado.
);

create table turma (
	id_turma INT generated always as identity,
	cod_curso VARCHAR (20) not null,
	periodo VARCHAR(10) not null,
	dias_horarios json not null,
	vagas_totais int not null default 0,
	
	constraint pk_turma primary key (id_turma),
	constraint ck_vagas check (vagas_totais >= 0),
	
	constraint fk_turma_curso foreign key (cod_curso)
		references curso (codigo)
		on update cascade 
		on delete restrict
);

create table matricula (
	id_matricula INT generated always as identity,
	id_turma INT not null,
	mat_aluno VARCHAR (20) not null,
	nota_final DECIMAL(5, 2) default 0.00,
	frequencia INT default 0,
	situacao VARCHAR(20) default 'CURSANDO',
	
	constraint pk_matricula primary key (id_matricula),
	
	-- regras de negócio
	constraint ck_nota_valida check (nota_final >= 0 and nota_final <= 100),
	constraint ck_frequencia_valida check (frequencia >= 0 and frequencia <= 100),
	constraint uq_aluno_turma unique (id_turma, mat_aluno),
	constraint ck_situacao_valida check (situacao in ('CURSANDO', 'APROVADO', 'REPROVADO', 'TRANCADO'))
	
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
('A0004', 'Eduardo Lima', 'edulima@email.com', 'ATIVO');

insert into turma (cod_curso, periodo, dias_horarios, vagas_totais) values
('SQL-01', '2026.1', '{"seg": "09:00"}', 20),
('DN-02',  '2026.1', '{"ter": "14:00"}', 15),
('IHC-03',  '2026.2', '{"sab": "08:00"}', 30);

insert into matricula (id_turma, mat_aluno, nota_final, frequencia, situacao) values
(1, 'A0001', 95.5, 100, 'APROVADO'),
(1, 'A0002', 45.0, 60, 'REPROVADO'),
(2, 'A0001', 88.0, 90, 'APROVADO'),
(3, 'A0004', 0.0, 0, 'CURSANDO');

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


-- para rodar cole o código no DBEAVER, faça a conexão com o PostgreSQL e dê um ALT + X.


