-- -----------------------------------------------------------------------------------------------------
-- TESTE 01: VERIFICAÇÃO DA RN10 (HORÁRIO DE SAIDA POSTERIOR AO DE ENTRADA)
-- REGRA: O sistema não deve permitir que o horário de saída seja cronologicamente anterior ao de entrada
-- RESTRIÇÃO DDL: ck_ponto_horario (CHECK na tabela Ponto)
-- OPERAÇÃO: INSERT
-- RESULTADO ESPERADO: O SGBD deve barrar a inserção com erro de violação de CHECK
-- ------------------------------------------------------------------------------------------------------

INSERT INTO Ponto (data_registro, hora_entrada, hora_saida, minutos_atraso, id_funcionario) VALUES ('2026-10-15', '17:00:00', '08:00:00', 0, 3);


-- -----------------------------------------------------------------------------------------------------
-- TESTE 02: VERIFICAÇÃO DE MINUTOS DE ATRASO NÃO-NEGATIVOS
-- REGRA: Os minutos de atraso de um ponto não podem ser negativos
-- RESTRIÇÃO DDL: ck_ponto_minutos_atraso (CHECK na tabela Ponto)
-- OPERAÇÃO: UPDATE
-- RESULTADO ESPERADO: O SGBD deve barrar a atualização com erro de violação de CHECK.
-- -----------------------------------------------------------------------------------------------------

UPDATE Ponto SET minutos_atraso = -10 WHERE id_registro = 1;


-- ----------------------------------------------------------------------------------------------------- 
-- TESTE 03: VERIFICAÇÃO DE PAUSA
-- REGRA: A pausa deve terminar depois de começar
-- RESTRIÇÃO DDL: ck_pausa_horario (CHECK na tabela Pausa)
-- OPERAÇÃO: INSERT
-- RESULTADO ESPERADO: O SGBD deve barrar a inserção com erro de violação de CHECK
-------------------------------------------------------------------------------------------------------

INSERT INTO Pausa (hora_inicio, hora_fim, id_registro) VALUES ('13:00:00','12:00:00',1);


-- ------------------------------------------------------------------------------------------------------- 
-- TESTE 04: VERIFICACÇÃO DA ESCALA DE TRABALHO
-- REGRA: O horário de saída da escala deve ser posterior ao de entrada, e o dia da semana deve ser válido
-- RESTRIÇÃO DDL: ck_escala_dia_semana (CHECK na tabela Escala_Trabalho)
-- OPERAÇÃO: INSERT
-- RESULTADO ESPERADO: O SGBD deve barrar a inserção com erro de violação de CHECK
-- -------------------------------------------------------------------------------------------------------

INSERT INTO Escala_Trabalho (descricao, dia_semana, horario_entrada, horario_saida) VALUES ('Escala dia Inválido', 7, '08:00:00','17:00:00');


-- -------------------------------------------------------------------------------------------------------
-- TESTE 05: VERIFICAÇÃO DO PERÍODO DE AUSÊNCIA
-- REGRA: No período de ausência, a data do fim deve ser igual ou posterior à de início.
-- RESTRIÇÃO DDL: ck_periodo_datas (CHECK na tabela Periodo_Ausencia)
-- OPERAÇÃO: INSERT
-- RESULTADO ESPERADO: O SGBD deve barrar a inserção com erro de violação da CHECK
-- ------------------------------------------------------------------------------------------------------

INSERT INTO Periodo_Ausencia(tipo, data_inicio, data_fim, id_funcionario) VALUES ('ferias', '2026-11-20', '2026-11-10',3);


-- ------------------------------------------------------------------------------------------------------
-- TESTE 06: VERIFICAÇÃO DE AUTOGERENCIA
-- REGRA: Um gerente não pode ser gerente de si mesmo
-- RESTRIÇÃO DDL: ck_funcionario_gerente (CHECK na tabela Funcionario)
-- OPERAÇÃO: UPDATE
-- RESULTADO ESPERADO: O SGBD deve barrar a atualização com erro de violação de CHECK.
-- ------------------------------------------------------------------------------------------------------

UPDATE Funcionario SET id_gerente = 1 WHERE id_funcionario = 1;


-- -----------------------------------------------------------------------------------------------------
-- TESTE 07: VERIFICAÇÃO DE ANÁLISE DE SOLICITAÇÃO
-- REGRA: Solicitação deferida ou indeferida precisa ter o gerente que a analisou, só a pendente pode ficar sem
-- RESTRIÇÃO DDL: ck_solicitacao_analise (CHECK na tabela Solicitacao)
-- OPERAÇÃO: UPDATE
-- RESULTADO ESPERADO: O SGBD deve barrar a atualização com erro de violação de CHECK
-- -----------------------------------------------------------------------------------------------------

UPDATE Solicitacao SET status = 'deferida', id_gerente = NULL WHERE id_solic = 1;


-- ------------------------------------------------------------------------------------------------------
-- TESTE 08: VERIFICAÇÃO DE DOMÍNIO E FORMADO DE CPF E SEXO
-- REGRA: O CPF deve ter exatamente 11 dígitos numéricos e o sexo de funcionário só aceita 'M' ou 'F'
-- RESTRIÇÃO DDL: ck_funcionario_cpf / ck_funcionario_sexo (CHECK em Funcionario)
-- OPERAÇÃO: INSERT
-- RESULTADO ESPERADO: O SGBD deve barrar a inserção com erro de violação de CHECK 
-- ------------------------------------------------------------------------------------------------------

INSERT INTO Funcionario (cpf, nome, sexo, email, data_admissao, id_departamento, id_cargo, id_gerente, status_funcionario) VALUES ('1234567890A', 'Teste CPF invalido', 'M', 'cpf.invalido@empresa.com','2026-10-01', 1,1,2,'ativo');


-- ------------------------------------------------------------------------------------------------------
-- TESTE 09: VERIFICAÇÃO DE AUTOGERÊNCIA (ADMIN / GERENTE_RH)
-- REGRA: Um administrador não pode gerenciar a si mesmo
-- RESTRIÇÃO DDL: ck_gerencia_rh_auto (CHECK na tabela Gerente_RH)
-- OPERAÇÃO: INSERT
-- RESULTADO ESPERADO: O SGBD deve barrar a inserção com erro de violação de CHECK
-- ------------------------------------------------------------------------------------------------------

INSERT INTO Gerencia_RH (id_admin, id_gerente) VALUES (1,1);

-- ------------------------------------------------------------------------------------------------------
-- TESTE 10: VERIFICAÇÃO DE QUANTIDADE POSITIVA EM HORA EXTRA
-- REGRA: A quantidade de horas extras deve ser maior que zero
-- RESTRIÇÃO DDL: ck_hora_extra_quantidade (CHECK na tabela Hora_Extra)
-- OPERAÇÃO: INSERT
-- RESULTADO ESPERADO: O SGBD deve barrar a inserção com erro de violação de CHECK.
-- ------------------------------------------------------------------------------------------------------

INSERT INTO Hora_Extra (quantidade, id_registro) VALUES (0.00, 1);

