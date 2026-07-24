-- ==============================================================================
-- 1. POBLAR CATÁLOGOS Y DIMENSIONES (1000 registros cada uno)
-- ==============================================================================

INSERT INTO dim_ramo (cod_ramo, ramo)
SELECT i, 'Ramo ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO dim_agrupador (cod_agrupador_principal, agrupador_principal, cod_agrupador_secundario, agrupador_secundario)
SELECT i, 'Agrupador P. ' || i, i, 'Agrupador S. ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO dim_agente (cod_agente_principal, agente_principal, cod_agente_secundario, agente_secundario, codigo_super_cias, identificacion)
SELECT i, 'Agente Principal ' || i, i, 'Agente Sec ' || i, 1000 + i, '172' || lpad(i::text, 7, '0') FROM generate_series(1, 1000) AS i;

INSERT INTO dim_punto_venta (cod_punto_venta, punto_venta)
SELECT i, 'Punto Venta ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO dim_ejecutivo (cod_ejecutivo, ejecutivo)
SELECT i, 'Ejecutivo ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO dim_canal_emision (cod_canal, canal_emision)
SELECT i, 'Canal Emisión ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO tpais (cod_pais, txt_desc)
SELECT i, 'País ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO tdpto (cod_dpto, cod_pais, txt_desc)
SELECT i, i, 'Departamento ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO tmunicipio (cod_municipio, cod_pais, cod_dpto, txt_desc)
SELECT i, i, i, 'Municipio ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO tcausa_stro (cod_causa, cod_ramo, txt_desc)
SELECT i, i, 'Causa Siniestro ' || i FROM generate_series(1, 1000) AS i;


-- ==============================================================================
-- 2. POBLAR TABLAS MAESTRAS DE PÓLIZAS Y VEHÍCULOS (1000 registros)
-- ==============================================================================

INSERT INTO pv_header (id_pv, cod_suc, cod_ramo, nro_pol, aaaa_endoso, nro_endoso, cod_aseg, fec_emi, fec_vig_desde, fec_vig_hasta, cod_tipo_agente, cod_agente, cod_grupo_endo, cod_tipo_endo, cod_grupo)
SELECT i, i, i, 10000 + i, 2026, i, i, '2026-01-01'::date + (i % 365), '2026-01-01'::date + (i % 365), '2026-12-31'::date, i, i, i, i, i FROM generate_series(1, 1000) AS i;

INSERT INTO tb_polizas (id_poliza, fecha_inicio_vig, fecha_fin_vig, cod_sucursal, sucursal, cod_ramo, cod_agrupador, cod_aseg, nombre_aseg, apellido_aseg, cedula, cod_producto, producto)
SELECT i, '2026-01-01'::date + (i % 365), '2026-12-31'::date, i, 'Sucursal ' || i, i, i, i, 'Nombre ' || i, 'Apellido ' || i, '099' || lpad(i::text, 7, '0'), i, 'Producto ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO tb_items (cod_item, id_poliza, cod_marca, marca, cod_modelo, modelo, chasis, placa, cod_color, color, cod_tipo_vh, tipo_vh, cod_clase_vh, clase_vh, cod_uso, uso, anio, direccion)
SELECT i, i, i, 'Marca ' || i, i, 'Modelo ' || i, 'CHAS' || i || 'X99', 'PCH-' || lpad((i % 9999)::text, 4, '0'), i, 'Color ' || i, i, 'Tipo ' || i, i, 'Clase ' || i, i, 'Uso ' || i, 2015 + (i % 12), 'Dirección ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO tb_cobertura (cod_cober, id_poliza, cod_item, cobertura, sn_activo)
SELECT i, i, i, 'asistencia vehicular', true FROM generate_series(1, 1000) AS i;


-- ==============================================================================
-- 3. POBLAR MÓDULO DE SINIESTROS Y RESERVAS (1000 registros)
-- ==============================================================================

INSERT INTO stro_header (id_stro, cod_suc, cod_ramo, aaaa_ejercicio, nro_stro, id_pv, fec_hora_reclamo, fec_aviso, fec_registro, cod_causa, cod_usuario)
SELECT i, i, i, 2026, 'STRO-2026-' || i, i, '2026-01-01'::date + (i % 365), '2026-01-02'::date + (i % 365), '2026-01-03'::date + (i % 365), i, 'UsuSist_' || i FROM generate_series(1, 1000) AS i;

INSERT INTO stro_op_header (id_stro_op, cod_suc, cod_ramo, nro_aut_tec, fec_emi, fec_pago, fec_estim_pago, fec_ingreso_contable, fec_anul, imp_total_pagar, txt_desc, cod_agente, nro_recibo_devengado, nro_recibo_pago, nro_op, cod_movimiento, txt_cheque_a_nom, nro_comprobante, txt_razon_social, cod_usuario, txt_reclamante)
SELECT i, i, i, 5000 + i, '2026-01-10'::date + (i % 350), '2026-01-15'::date + (i % 350), '2026-01-12'::date + (i % 350), '2026-01-14'::date + (i % 350), null, (random() * 2500)::numeric(15,2), 'Pago Aut ' || i, i, i, i, i, i, 'Beneficiario ' || i, i, 'Taller RS ' || i, 'UsuCaja_' || i, 'Reclamante ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO stro_op_pagos (id_stro_op, id_stro, cod_item, cod_ind_cob, cod_tercero, cod_tipo_pago, imp_pago, cod_clase_pago, cod_ramo)
SELECT i, i, i, i, i, i, (random() * 1000)::numeric(15,2), i, i FROM generate_series(1, 1000) AS i;

INSERT INTO estim_header (id_stro, cod_item, cod_ind_cob, txt_bien_strado, cod_municipio, cod_dpto, cod_pais, id_pv, cod_ramo)
SELECT i, i, i, 'Bien Asegurado ' || i, i, i, i, i, i FROM generate_series(1, 1000) AS i;

INSERT INTO estim_importe (id_stro, cod_item, cod_ind_cob, cod_estim, nro_correla_estim, fec_estim, cod_tipo_estim, imp_estimado, cod_usuario)
SELECT i, i, i, i, i, '2026-01-05'::date + (i % 360), i, (random() * 3000)::numeric(15,2), 'UsuReserva_' || i FROM generate_series(1, 1000) AS i;


-- ==============================================================================
-- 4. POBLAR TABLAS COMERCIALES (1000 registros)
-- ==============================================================================

INSERT INTO produccion_2026 (cod_tipo_produccion, tipo_produccion, anio, numero_mes, mes, fecha, sucursal, cod_ramo, cod_tipo_agente, tipo_agente, cod_agente, agente, poliza, endoso, cod_contratante, contratante, cod_asegurado, asegurado, cedula_asegurado, fecha_emision, vigencia_desde, vigencia_hasta, canal_emision, agrupador, agrupador_principal, prima, punto_vta, tipo_endoso, motivo_endoso, pertenece_grupo, pago_inicial, ejecutivo_comercial)
SELECT i, 'Nueva', 2026, (i % 12) + 1, 'Mes ' || ((i % 12) + 1), '2026-01-01'::date + (i % 365), 'Sucursal ' || (i % 10), i, i, 'Broker', i, 'Agente ' || i, i, i, i, 'Contratante ' || i, i, 'Asegurado ' || i, '170' || lpad(i::text, 7, '0'), '2026-01-01'::date + (i % 365), '2026-01-01'::date + (i % 365), '2026-12-31'::date, 'Directo', 'Grupo ' || i, 'Holding ' || i, (random() * 6000)::numeric(15,2), 'PV ' || i, 'Emisión', 'Alta Nueva', 'SI', 'Tarjeta', 'Ejecutivo ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO presupuesto_2026 (cod_tipo_produccion, tipo_produccion, anio, numero_mes, mes, fecha, cod_ramo, cod_tipo_agente, tipo_agente, cod_agente, agente, canal_emision, agrupador, agrupador_principal, presupuesto, punto_vta, pertenece_grupo, ejecutivo_comercial)
SELECT i, 'Presupuestado', 2026, (i % 12) + 1, 'Mes ' || ((i % 12) + 1), '2026-01-01'::date + (i % 365), i, i, 'Broker', i, 'Agente ' || i, 'Directo', 'Grupo ' || i, 'Holding ' || i, (random() * 12000)::numeric(15,2), 'PV ' || i, 'SI', 'Ejecutivo ' || i FROM generate_series(1, 1000) AS i;

INSERT INTO renovaciones_2026 (anio, numero_mes, mes, fecha, sucursal, cod_ramo, cod_tipo_agente, tipo_agente, cod_agente, agente, poliza, endoso, cod_contratante, contratante, cod_asegurado, asegurado, cedula_asegurado, vigencia_desde, vigencia_hasta, canal_emision, agrupador, agrupador_principal, prima_a_renovar, punto_vta, ejecutivo_comercial, estado_renovacion)
SELECT 2026, (i % 12) + 1, 'Mes ' || ((i % 12) + 1), '2026-01-01'::date + (i % 365), 'Sucursal ' || (i % 10), i, i, 'Broker', i, 'Agente ' || i, i, i, i, 'Contratante ' || i, i, 'Asegurado ' || i, '170' || lpad(i::text, 7, '0'), '2026-01-01'::date + (i % 365), '2026-12-31'::date, 'Directo', 'Grupo ' || i, 'Holding ' || i, (random() * 4000)::numeric(15,2), 'PV ' || i, 'Ejecutivo ' || i, 'Pendiente' FROM generate_series(1, 1000) AS i;

INSERT INTO kpi_crm (anio, numero_mes, mes, fecha, cod_ramo, cod_tipo_agente, tipo_agente, cod_agente, agente, canal_emision, prima_target, punto_vta, ejecutivo_comercial, cliente, quotation, hit_ratio, etapa_actual, estado)
SELECT 2026, (i % 12) + 1, 'Mes ' || ((i % 12) + 1), '2026-01-01'::date + (i % 365), i, i, 'Broker', i, 'Agente ' || i, 'Brokerage', (random() * 8000)::numeric(15,2), 'PV ' || i, 'Ejecutivo ' || i, 'Prospecto ' || i, 'Q-' || (1000+i), (random() * 100)::int || '%', 'Negociación', 'Abierto' FROM generate_series(1, 1000) AS i;

INSERT INTO asesores_productores_seguros_scvs (agente, codigo_super_cias, ramo, prima, fecha)
SELECT 'Agente SCVS ' || i, 9000 + i, 'Ramo ' || i, (random() * 9000)::numeric(15,2), '2026-01-01'::date + (i % 365) FROM generate_series(1, 1000) AS i;


-- ==============================================================================
-- 5. POBLAR BANCA SEGUROS / PAGOS MASIVOS (1000 registros)
-- ==============================================================================

INSERT INTO sabana_polizas_emasivos (id_cliente, asegurado, fecha_emision, ramo, producto, sucursal, primer_apellido, segundo_apellido, nombres, prima_neta)
SELECT 'CLI-' || i, 'Asegurado EM ' || i, '2026-01-01'::date + (i % 365), 'Desgravamen', 'Vida Segura', 'Sucursal ' || (i % 5), 'P_Ape ' || i, 'S_Ape ' || i, 'Nombres ' || i, (random() * 250)::numeric(15,2) FROM generate_series(1, 1000) AS i;

INSERT INTO oficio_pagos_recurrentes (rfc_titular, segmento, tarjeta, nombres_afiliado, fecha_venta, oficio, carga, mes, valor, estado, asistencias, plan)
SELECT 'RFC' || lpad(i::text, 6, '0'), 'Segmento VIP', '4000-1234-5678-' || lpad((i % 9999)::text, 4, '0'), 'Afiliado ' || i, '2026-01-01'::date + (i % 365), 'OF-2026-' || i, 'Carga ' || i, 'Mes ' || ((i % 12) + 1), (random() * 80)::numeric(15,2), 'Cobrado', 'Asistencia Full', 'Plan Tranquilidad' FROM generate_series(1, 1000) AS i;

INSERT INTO sabana_pagos_emasivos (campo_ultimo_mes, campo_cedula, campo_forma_pago)
SELECT 'Mes ' || ((i % 12) + 1), '099' || lpad(i::text, 7, '0'), 'Débito Cuenta' FROM generate_series(1, 1000) AS i;