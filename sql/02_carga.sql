-- =====================================================================================================
-- 02_carga.sql
-- Carga inicial de dados para o sistema de Gerenciamento de Ponto Eletrônico
-- SGBD: PostgreSQL 14+
-- =====================================================================================================

BEGIN;

-- -----------------------------------------------------------------------------------------------------
-- 1. Departamento (IDs 1..8)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Departamento (nome_departamento) VALUES
    ('Recursos Humanos'),
    ('Tecnologia da Informação'),
    ('Financeiro'),
    ('Comercial'),
    ('Operações'),
    ('Logística'),
    ('Jurídico'),
    ('Marketing');

-- -----------------------------------------------------------------------------------------------------
-- 2. Cargo (IDs 1..10)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Cargo (nome_cargo, descricao) VALUES
    ('Gerente de RH', 'Responsável pela gestão de pessoas, escalas, faltas e solicitações'),
    ('Administrador de Sistemas', 'Responsável pela administração e manutenção do sistema de ponto'),
    ('Analista de Sistemas', 'Desenvolvimento e manutenção de sistemas corporativos'),
    ('Desenvolvedor', 'Implementação de software e integrações'),
    ('Analista Financeiro', 'Controle financeiro, folha de pagamento e conciliação'),
    ('Assistente Administrativo', 'Apoio operacional e documental aos setores'),
    ('Coordenador de Operações', 'Supervisão de turnos e produtividade operacional'),
    ('Vendedor', 'Atendimento comercial e prospecção de clientes'),
    ('Analista de Marketing', 'Gestão de campanhas e comunicação institucional'),
    ('Advogado', 'Assessoria jurídica trabalhista e contratual');

-- -----------------------------------------------------------------------------------------------------
-- 3. Escala_Trabalho (IDs 1..10: turnos comerciais e flexíveis de segunda a sexta)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Escala_Trabalho (descricao, dia_semana, horario_entrada, horario_saida) VALUES
    ('Comercial 08h-17h - Segunda', 1, '08:00:00', '17:00:00'),
    ('Comercial 08h-17h - Terça',   2, '08:00:00', '17:00:00'),
    ('Comercial 08h-17h - Quarta',  3, '08:00:00', '17:00:00'),
    ('Comercial 08h-17h - Quinta',  4, '08:00:00', '17:00:00'),
    ('Comercial 08h-17h - Sexta',   5, '08:00:00', '17:00:00'),
    ('Flexível 09h-18h - Segunda',  1, '09:00:00', '18:00:00'),
    ('Flexível 09h-18h - Terça',    2, '09:00:00', '18:00:00'),
    ('Flexível 09h-18h - Quarta',   3, '09:00:00', '18:00:00'),
    ('Flexível 09h-18h - Quinta',   4, '09:00:00', '18:00:00'),
    ('Flexível 09h-18h - Sexta',    5, '09:00:00', '18:00:00');

-- -----------------------------------------------------------------------------------------------------
-- 4. Funcionario (IDs 1..1000)
--    Admissões até 2024-11-30 para preceder todos os registros de falta (dez/2024) e ponto (2025).
--    Funcionários 1..950 ativos; 951..1000 inativos (não registram ponto em 2025).
--    id_gerente é inserido inicialmente como NULL por causa da FK circular com Gerente_RH.
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Funcionario (
    cpf, nome, sexo, email, data_admissao, id_departamento, id_cargo, id_gerente, status_funcionario
) VALUES
    ('10000000001', 'Ana Paula Souza',       'F', 'ana.souza@empresa.com.br',       '2019-03-01', 1, 1, NULL, 'ativo'),
    ('10000000002', 'Carlos Eduardo Lima',   'M', 'carlos.lima@empresa.com.br',     '2020-01-15', 1, 1, NULL, 'ativo'),
    ('10000000003', 'Mariana Ferreira Costa','F', 'mariana.costa@empresa.com.br',   '2022-05-10', 2, 3, NULL, 'ativo'),
    ('10000000004', 'Roberto Almeida Silva', 'M', 'roberto.silva@empresa.com.br',   '2018-07-20', 2, 2, NULL, 'ativo'),
    ('10000000005', 'Fernanda Oliveira Dias','F', 'fernanda.dias@empresa.com.br',   '2019-11-04', 2, 2, NULL, 'ativo'),
    ('10000000006', 'Lucas Mendes Rocha',    'M', 'lucas.rocha@empresa.com.br',     '2021-02-08', 1, 1, NULL, 'ativo'),
    ('10000000007', 'Juliana Pereira Gomes', 'F', 'juliana.gomes@empresa.com.br',   '2021-06-14', 1, 1, NULL, 'ativo'),
    ('10000000008', 'Ricardo Santos Alves',  'M', 'ricardo.alves@empresa.com.br',   '2022-01-10', 1, 1, NULL, 'ativo'),
    ('10000000009', 'Patrícia Barbosa Nunes','F', 'patricia.nunes@empresa.com.br',  '2022-08-22', 1, 1, NULL, 'ativo'),
    ('10000000010', 'Gabriel Martins Pinto', 'M', 'gabriel.pinto@empresa.com.br',   '2023-03-13', 1, 1, NULL, 'ativo');

INSERT INTO Funcionario (
    cpf, nome, sexo, email, data_admissao, id_departamento, id_cargo, id_gerente, status_funcionario
)
SELECT
    LPAD((10000000000 + g)::TEXT, 11, '0') AS cpf,
    'Funcionário ' || g AS nome,
    CASE WHEN g % 2 = 0 THEN 'M' ELSE 'F' END AS sexo,
    'funcionario' || g || '@empresa.com.br' AS email,
    DATE '2019-01-01' + ((g * 7) % 2100) AS data_admissao,
    ((g - 1) % 8) + 1 AS id_departamento,
    ((g - 1) % 8) + 3 AS id_cargo,
    NULL AS id_gerente,
    CASE WHEN g > 950 THEN 'inativo' ELSE 'ativo' END AS status_funcionario
FROM generate_series(11, 1000) AS g;

-- -----------------------------------------------------------------------------------------------------
-- 5. Gerente_RH, Admin e Gerencia_RH
--    ID 1 é Admin e Gerente_RH (usado no TESTE 09 de 03_verificacao.sql).
--    ID 2 é Gerente_RH (usado no TESTE 08 de 03_verificacao.sql).
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Gerente_RH (id_funcionario)
SELECT g FROM generate_series(1, 10) AS g WHERE g <> 3;

INSERT INTO Admin (id_gerente) VALUES (1), (4), (5);

INSERT INTO Gerencia_RH (id_admin, id_gerente) VALUES
    (1, 2),
    (1, 6),
    (1, 7),
    (4, 8),
    (4, 9),
    (5, 10);

-- Atualiza id_gerente dos funcionários após popular Gerente_RH (nunca autogerência)
UPDATE Funcionario
SET id_gerente = 2
WHERE id_funcionario = 1;

UPDATE Funcionario
SET id_gerente = 1
WHERE id_funcionario = 2;

UPDATE Funcionario
SET id_gerente = CASE
    WHEN id_funcionario % 5 = 0 THEN 1
    WHEN id_funcionario % 5 = 1 THEN 2
    WHEN id_funcionario % 5 = 2 THEN 6
    WHEN id_funcionario % 5 = 3 THEN 7
    ELSE 8
END
WHERE id_funcionario >= 3
  AND id_funcionario NOT IN (6, 7, 8);

UPDATE Funcionario
SET id_gerente = 1
WHERE id_funcionario IN (6, 7, 8);

-- -----------------------------------------------------------------------------------------------------
-- 6. Contato_Emergencia (1.000 linhas)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Contato_Emergencia (nome_contato, telefone_contato, parentesco, id_funcionario)
SELECT
    'Contato de ' || f.nome,
    '(31) 9' || LPAD((80000000 + f.id_funcionario)::TEXT, 8, '0'),
    CASE (f.id_funcionario % 4)
        WHEN 0 THEN 'Cônjuge'
        WHEN 1 THEN 'Mãe'
        WHEN 2 THEN 'Pai'
        ELSE 'Irmão(ã)'
    END,
    f.id_funcionario
FROM Funcionario AS f;

-- -----------------------------------------------------------------------------------------------------
-- 7. Funcionario_Telefone (1.200 linhas: 1 telefone principal + secundário para 200 funcionários)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Funcionario_Telefone (id_funcionario, telefone)
SELECT
    f.id_funcionario,
    '(31) 9' || LPAD((90000000 + f.id_funcionario)::TEXT, 8, '0')
FROM Funcionario AS f;

INSERT INTO Funcionario_Telefone (id_funcionario, telefone)
SELECT
    f.id_funcionario,
    '(31) 3' || LPAD((2000000 + f.id_funcionario)::TEXT, 7, '0')
FROM Funcionario AS f
WHERE f.id_funcionario <= 200;

-- -----------------------------------------------------------------------------------------------------
-- 8. Cumpre (5.000 linhas: 5 dias úteis por funcionário)
--    Ímpares: escala 1..5 (08h-17h); Pares: escala 6..10 (09h-18h).
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Cumpre (id_funcionario, id_escala, status)
SELECT
    f.id_funcionario,
    CASE WHEN f.id_funcionario % 2 = 1 THEN d ELSE d + 5 END AS id_escala,
    CASE WHEN f.id_funcionario > 930 AND f.status_funcionario = 'ativo' THEN 'pendente' ELSE 'aprovada' END AS status
FROM Funcionario AS f
CROSS JOIN generate_series(1, 5) AS d;

-- -----------------------------------------------------------------------------------------------------
-- 9. Ponto (237.500 linhas: 950 funcionários ativos x 250 dias úteis a partir de segunda 2025-01-06)
--    Coerente com a escala do funcionário:
--      - Somente dias úteis (segunda a sexta), correspondendo a Escala_Trabalho.dia_semana (1..5).
--      - hora_entrada alinhada ao horário da escala (08:00 ou 09:00) + variação de -5 a +19 min.
--      - minutos_atraso calculado exatamente como GREATEST(0, hora_entrada - horario_entrada).
--      - hora_saida alinhada ao horário da escala (17:00 ou 18:00), com hora extra a cada 10 dias.
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Ponto (data_registro, hora_entrada, hora_saida, minutos_atraso, id_funcionario)
SELECT
    DATE '2025-01-06' + ((d / 5) * 7) + (d % 5) AS data_registro,
    e.horario_entrada + (v.delta_entrada * INTERVAL '1 minute') AS hora_entrada,
    CASE
        WHEN d = 249 AND f > 940 THEN NULL
        WHEN (f + d) % 10 = 0 THEN e.horario_saida + ((((f + d) % 3) + 1) * INTERVAL '30 minutes')
        ELSE e.horario_saida
    END AS hora_saida,
    GREATEST(0, v.delta_entrada) AS minutos_atraso,
    f AS id_funcionario
FROM generate_series(1, 950) AS f
CROSS JOIN generate_series(0, 249) AS d
CROSS JOIN LATERAL (
    SELECT
        CASE WHEN f % 2 = 1 THEN TIME '08:00:00' ELSE TIME '09:00:00' END AS horario_entrada,
        CASE WHEN f % 2 = 1 THEN TIME '17:00:00' ELSE TIME '18:00:00' END AS horario_saida
) AS e
CROSS JOIN LATERAL (
    SELECT (((f + d) % 25) - 5) AS delta_entrada
) AS v;

-- -----------------------------------------------------------------------------------------------------
-- 10. Pausa (100.000 linhas: intervalos de almoço dentro do expediente)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Pausa (hora_inicio, hora_fim, id_registro)
SELECT
    TIME '12:00:00' + ((p.id_registro % 30) * INTERVAL '1 minute') AS hora_inicio,
    TIME '13:00:00' + ((p.id_registro % 30) * INTERVAL '1 minute') AS hora_fim,
    p.id_registro
FROM Ponto AS p
WHERE p.id_registro <= 100000
  AND p.hora_saida IS NOT NULL;

-- -----------------------------------------------------------------------------------------------------
-- 11. Hora_Extra (calculada exatamente a partir de Ponto.hora_saida - Escala_Trabalho.horario_saida)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Hora_Extra (quantidade, id_registro)
SELECT
    ROUND((EXTRACT(EPOCH FROM (p.hora_saida - e.horario_saida)) / 3600.0)::NUMERIC, 2) AS quantidade,
    p.id_registro
FROM Ponto AS p
JOIN Cumpre AS c
  ON c.id_funcionario = p.id_funcionario
JOIN Escala_Trabalho AS e
  ON e.id_escala = c.id_escala
 AND e.dia_semana = EXTRACT(DOW FROM p.data_registro)::INT
WHERE p.hora_saida IS NOT NULL
  AND p.hora_saida > e.horario_saida;

-- -----------------------------------------------------------------------------------------------------
-- 12. Periodo_Ausencia (200 linhas: em 2026, para funcionários ativos, sem sobrepor Ponto de 2025)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Periodo_Ausencia (tipo, data_inicio, data_fim, id_funcionario)
SELECT
    CASE (g % 3)
        WHEN 0 THEN 'ferias'
        WHEN 1 THEN 'folga'
        ELSE 'licenca'
    END AS tipo,
    (DATE '2026-01-05' + ((g % 180) * INTERVAL '1 day'))::DATE AS data_inicio,
    (DATE '2026-01-05' + ((g % 180) * INTERVAL '1 day'))::DATE
        + CASE (g % 3) WHEN 0 THEN 14 WHEN 1 THEN 1 ELSE 5 END AS data_fim,
    g AS id_funcionario
FROM generate_series(1, 200) AS g;

-- -----------------------------------------------------------------------------------------------------
-- 13. Falta (300 linhas: dias úteis de dez/2024, sem conflito com Ponto de 2025 nem Periodo_Ausencia)
--     id_gerente sempre diferente de id_funcionario.
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Falta (data_falta, status_justificativa, id_funcionario, id_gerente)
SELECT
    DATE '2024-12-02' + (((g % 15) / 5) * 7) + ((g % 15) % 5) AS data_falta,
    CASE
        WHEN g BETWEEN 101 AND 200 AND (g % 3 = 0) THEN 'abonada'
        WHEN g % 3 = 1 THEN 'pendente'
        ELSE 'sem_justificativa'
    END AS status_justificativa,
    g AS id_funcionario,
    CASE WHEN g = 1 THEN 2 ELSE 1 END AS id_gerente
FROM generate_series(1, 300) AS g;

-- -----------------------------------------------------------------------------------------------------
-- 14. Solicitacao (200 linhas: 1..100 para Justificativa_Atraso, 101..200 para Abono_Falta)
--     id_solic = 1 fica como 'pendente' (id_gerente NULL) para o TESTE 07 de 03_verificacao.sql.
--     id_gerente (quando analisada) sempre diferente de id_funcionario.
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Solicitacao (data_solic, status, descricao, id_funcionario, id_gerente)
VALUES
    ('2025-12-20', 'pendente', 'Justificativa de atraso por problema no transporte público', 3, NULL);

-- Solicitações 2..100: vinculadas a funcionários que possuem pontos com atraso
WITH atrasos_amostra AS (
    SELECT
        p.id_funcionario,
        p.data_registro,
        ROW_NUMBER() OVER (ORDER BY p.id_registro) + 1 AS seq
    FROM Ponto AS p
    WHERE p.minutos_atraso > 0
      AND p.id_funcionario <> 3
    LIMIT 99
)
INSERT INTO Solicitacao (data_solic, status, descricao, id_funcionario, id_gerente)
SELECT
    a.data_registro + 1 AS data_solic,
    CASE (a.seq % 3)
        WHEN 0 THEN 'deferida'
        WHEN 1 THEN 'indeferida'
        ELSE 'pendente'
    END AS status,
    'Justificativa de atraso referente ao dia ' || TO_CHAR(a.data_registro, 'DD/MM/YYYY') AS descricao,
    a.id_funcionario,
    CASE
        WHEN a.seq % 3 = 2 THEN NULL
        WHEN a.id_funcionario = 1 THEN 2
        ELSE 1
    END AS id_gerente
FROM atrasos_amostra AS a
ORDER BY a.seq;

-- Solicitações 101..200: vinculadas às faltas 101..200 (mesmo funcionário e data >= data_falta)
INSERT INTO Solicitacao (data_solic, status, descricao, id_funcionario, id_gerente)
SELECT
    f.data_falta + 2 AS data_solic,
    CASE
        WHEN f.status_justificativa = 'abonada' THEN 'deferida'
        WHEN f.status_justificativa = 'pendente' THEN 'pendente'
        ELSE 'indeferida'
    END AS status,
    'Solicitação de abono de falta referente ao dia ' || TO_CHAR(f.data_falta, 'DD/MM/YYYY') AS descricao,
    f.id_funcionario,
    CASE
        WHEN f.status_justificativa = 'pendente' THEN NULL
        WHEN f.id_funcionario = 1 THEN 2
        ELSE 1
    END AS id_gerente
FROM Falta AS f
WHERE f.id_falta BETWEEN 101 AND 200
ORDER BY f.id_falta;

-- -----------------------------------------------------------------------------------------------------
-- 15. Justificativa_Atraso (100 linhas: solicitações 1..100 ligadas ao respectivo Ponto com atraso)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Justificativa_Atraso (id_solic, id_registro)
SELECT
    1 AS id_solic,
    (
        SELECT p.id_registro
        FROM Ponto AS p
        WHERE p.id_funcionario = 3
          AND p.minutos_atraso > 0
        ORDER BY p.id_registro
        LIMIT 1
    ) AS id_registro;

WITH atrasos_amostra AS (
    SELECT
        p.id_registro,
        ROW_NUMBER() OVER (ORDER BY p.id_registro) + 1 AS id_solic
    FROM Ponto AS p
    WHERE p.minutos_atraso > 0
      AND p.id_funcionario <> 3
    LIMIT 99
)
INSERT INTO Justificativa_Atraso (id_solic, id_registro)
SELECT
    a.id_solic,
    a.id_registro
FROM atrasos_amostra AS a;

-- -----------------------------------------------------------------------------------------------------
-- 16. Abono_Falta (100 linhas: solicitações 101..200)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Abono_Falta (id_solic)
SELECT g FROM generate_series(101, 200) AS g;

-- -----------------------------------------------------------------------------------------------------
-- 17. Abona (100 linhas: relaciona cada Abono_Falta à Falta do mesmo funcionário)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Abona (id_solic, id_falta)
SELECT
    g AS id_solic,
    g AS id_falta
FROM generate_series(101, 200) AS g;

-- -----------------------------------------------------------------------------------------------------
-- 18. Anexo_Comprovante (120 linhas)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Anexo_Comprovante (caminho_comprovante, formato, tamanho_mb, id_solic)
SELECT
    '/storage/comprovantes/2025/anexo_' || LPAD(g::TEXT, 4, '0') || '.pdf' AS caminho_comprovante,
    CASE WHEN g % 3 = 0 THEN 'png' ELSE 'pdf' END AS formato,
    ROUND((0.25 + ((g % 10) * 0.35))::NUMERIC, 2) AS tamanho_mb,
    g AS id_solic
FROM generate_series(1, 120) AS g;

-- -----------------------------------------------------------------------------------------------------
-- 19. Notificacao (5.000 linhas)
-- -----------------------------------------------------------------------------------------------------
INSERT INTO Notificacao (tipo, mensagem, data, lida, id_funcionario)
SELECT
    CASE (g % 4)
        WHEN 0 THEN 'atraso'
        WHEN 1 THEN 'falta'
        WHEN 2 THEN 'limite_faltas'
        ELSE 'resultado_analise'
    END AS tipo,
    CASE (g % 4)
        WHEN 0 THEN 'Atraso registrado no ponto eletrônico.'
        WHEN 1 THEN 'Nova falta registrada pelo RH.'
        WHEN 2 THEN 'Atenção: você se aproximou do limite mensal de faltas.'
        ELSE 'Sua solicitação foi analisada pelo Gerente de RH.'
    END AS mensagem,
    TIMESTAMP '2025-02-01 09:00:00' + (g * INTERVAL '1 hour') AS data,
    (g % 2 = 0) AS lida,
    ((g - 1) % 950) + 1 AS id_funcionario
FROM generate_series(1, 5000) AS g;

COMMIT;

-- Atualiza as estatísticas do otimizador de consultas após a carga em massa
ANALYZE;
