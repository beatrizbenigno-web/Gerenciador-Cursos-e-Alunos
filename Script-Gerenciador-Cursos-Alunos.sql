
create table curso (
	codigo VARCHAR(20) not null,
	nome VARCHAR(150) not null,
	carga_horaria INT not null,
	
	constraint pk_curso primary key (codigo),
	constraint ck_carga_horaria check (carga_horaria > 0)
);


create table aluno (
	matricula VARCHAR(20) not null,
	nome VARCHAR(150) not null,
	email VARCHAR(150),
	status_academico VARCHAR(50) default 'ATIVO',
	
	constraint pk_aluno primary key (matricula),
	constraint uq_aluno_email unique (email)
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







