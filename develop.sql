
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

comment on table curso is 'Catálogo de cursos disponíveis.';


create table aluno (
	matricula VARCHAR(20) not null,
	nome VARCHAR(150) not null,
	email VARCHAR(150),
	status_academico VARCHAR(50) default 'ATIVO',
	-- o DEFAULT tem a função de atribuir automaticamente o status do aluno, caso niguém escreva. 
	-- então já fica como ATIVO.
	
	constraint pk_aluno primary key (matricula),
	constraint uq_aluno_email unique (email)
	CONSTRAINT ck_status_aluno check (status_academico IN ('ATIVO', 'INATIVO', 'TRANCADO', 'FORMADO'))
);

comment on table aluno is 'Registro de dados dos estudantes.';

create table turma (
	id_turma INT generated always as identity,
	cod_curso VARCHAR (20) not null,
	periodo VARCHAR(10) not null,
	dias_horarios json not null,
	vagas_totais int not null default 0,
	
	constraint pk_turma primary key (id_turma),
	constraint ck_vagas check (vagas_totais >= 0),
	-- em vagas totais, o valor pode ser maior ou igual a 0.
	constraint fk_turma_curso foreign key (cod_curso)
		references curso (codigo)
		on update cascade 
		on delete restrict
);

comment on table turma is 'Oferta de disciplinas em períodos específicos.';

create table matricula (
	id_matricula INT generated always as identity,
	id_turma INT not null,
	mat_aluno VARCHAR (20) not null,
	nota_final DECIMAL(5, 2) default 0.00,
	frequencia INT default 0,
	situacao VARCHAR(20) default 'CURSANDO',

	-- aqui ele automaticamente diz como está a situação da matricula do aluno, caso ninguém descreva outra situação.
	
	constraint pk_matricula primary key (id_matricula),
	
	-- regras de negócio
	constraint ck_nota_valida check (nota_final >= 0 and nota_final <= 100),
	constraint ck_frequencia_valida check (frequencia >= 0 and frequencia <= 100),
	constraint ck_situacao_valida check (situacao in ('CURSANDO', 'APROVADO', 'REPROVADO', 'TRANCADO'))
	constraint uq_aluno_turma unique (id_turma, mat_aluno),
	
	-- chaves estrangeiras
	constraint fk_matricula_turma foreign key (id_turma)
		references turma (id_turma)
		on update cascade
		on delete restrict,
	
	constraint fk_matricula_aluno foreign key (mat_aluno)
		references aluno (matricula)
		on update cascade
		on delete cascade
);

comment on table matricula is 'Registro do vínculo entre alunos e turmas (notas e frequêcia).'

-- Criar o Curso
insert into curso (codigo, nome, carga_horaria)
values ('SQL-Banco de Dados', 'Introdução ao SQL', 45);

-- Criar o Aluno
insert into aluno (matricula, nome, email, status_academico)
values ('A0001', 'Beatriz Benigno', 'beatrizbenigno@gmail.com', 'ATIVO');

-- Criar a Turma (Ligada ao curso SQL-Banco de Dados)
-- O banco vai gerar automaticamente o id_turma como 1
insert into turma (cod_curso, periodo, dias_horarios, vagas_totais)
values ('SQL-Banco de Dados', '2026.1', '{"seg": "09:00"}', 20);

-- Matricular o Aluno na Turma
-- Estamos a assumir que a turma criada acima recebeu o id 1
insert into matricula (id_turma, mat_aluno, nota_final, frequencia)
values (1, 'A0001', 95.5, 100);

select * from matricula;
select * from aluno;
select * from curso;
select * from turma;
