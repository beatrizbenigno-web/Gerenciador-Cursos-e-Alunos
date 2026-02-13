# 🎓 Sistema de Gerenciamento de Cursos de Alunos (SQL)

Este projeto consiste na modelagem e implementação de um banco de dados relacional para gerenciar uma instituição de ensino. O sistema controla **Cursos, Alunos, Turmas e Matrículas**, permitindo o registro de notas, frequência e situações acadêmicas.

Desenvolvido como requisito para a disciplina de Banco de Dados.

## Tecnologias Utilizadas

- **Linguagem:** SQL 
- **SGBD:** PostgreSQL
- **Ferramenta de Gerenciamento:** DBeaver

## Estrutura do Banco de Dados

O sistema é composto por 4 tabelas principais relacionais:

1.  Curso: Catálogo das disciplinas ofertadas (com carga horária e validações).
2.  Aluno: Dados cadastrais dos estudantes.
3.  Turma: Ofertas específicas dos cursos (com controle de vagas e horários via JSON).
4.  Matrícula: Tabela associativa que vincula Alunos às Turmas, armazenando notas e frequência.

### Regras de Negócio Implementadas (Constraints)
- Integridade Referencial: Chaves Estrangeiras (FK) com `ON UPDATE CASCADE`.
- Validação de Dados:
    * Notas devem ser entre 0 e 100.
    * Frequência deve ser entre 0 e 100.
    * Carga horária e vagas devem ser positivas.
- Automação: Situação da matrícula inicia automaticamente como 'CURSANDO'.
- Lista Permitida: A coluna `situacao` aceita apenas: 'CURSANDO', 'APROVADO', 'REPROVADO', 'TRANCADO'.

## Como Executar o Projeto

Para testar este banco de dados, você precisará de uma ferramenta SQL (recomendado **DBeaver**).

### Passo a Passo:

1.  **Clone ou baixe** este repositório.
2.  Abra o arquivo `script_completo.sql` no DBeaver.
3.  Conecte-se ao seu banco de dados PostgreSQL.
4.  **Execute o script inteiro de uma vez** (No DBeaver, use o atalho `Alt + X`).

## Consultas Incluídas

O script final executa automaticamente 5 relatórios demonstrativos:
1.  **Boletim Geral:** Lista Aluno, Curso, Nota e Situação.
2.  **Diário de Classe:** Filtra alunos de uma turma específica.
3.  **Relatório de Reprovados:** Busca alunos com status 'REPROVADO'.
4.  **Auditoria de Oferta:** Lista todos os cursos, inclusive os sem turma (LEFT JOIN).
5.  **Histórico Escolar:** Filtra todas as matérias de um aluno específico.
