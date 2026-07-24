-- ==============================================================================
-- 1. CATÁLOGOS Y DIMENSIONES (DAVID Y SANTIAGO)
-- ==============================================================================

CREATE TABLE dim_ramo (
    cod_ramo INT PRIMARY KEY,
    ramo VARCHAR(150)
);

CREATE TABLE dim_agente (
    cod_agente_principal INT PRIMARY KEY,
    agente_principal VARCHAR(250),
    cod_agente_secundario INT,
    agente_secundario VARCHAR(250),
    codigo_super_cias INT,
    identificacion VARCHAR(50)
);

CREATE TABLE dim_punto_venta (
    cod_punto_venta INT PRIMARY KEY,
    punto_venta VARCHAR(250)
);

CREATE TABLE dim_ejecutivo (
    cod_ejecutivo INT PRIMARY KEY,
    ejecutivo VARCHAR(250)
);

CREATE TABLE dim_agrupador (
    cod_agrupador_principal INT PRIMARY KEY,
    agrupador_principal VARCHAR(250),
    cod_agrupador_secundario INT,
    agrupador_secundario VARCHAR(250)
);

CREATE TABLE dim_canal_emision (
    cod_canal INT PRIMARY KEY,
    canal_emision VARCHAR(250)
);

-- Catálogos Geográficos y Parámetros (Santiago)
CREATE TABLE tpais (
    cod_pais INT PRIMARY KEY,
    txt_desc VARCHAR(250)
);

CREATE TABLE tdpto (
    cod_dpto INT PRIMARY KEY,
    cod_pais INT REFERENCES tpais(cod_pais),
    txt_desc VARCHAR(250)
);

CREATE TABLE tmunicipio (
    cod_municipio INT PRIMARY KEY,
    cod_pais INT REFERENCES tpais(cod_pais),
    cod_dpto INT REFERENCES tdpto(cod_dpto),
    txt_desc VARCHAR(250)
);

CREATE TABLE tcausa_stro (
    cod_causa INT PRIMARY KEY,
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    txt_desc VARCHAR(250)
);

-- ==============================================================================
-- 2. TABLAS MAESTRAS DE PÓLIZAS Y VEHÍCULOS (GIANNI & SANTIAGO)
-- ==============================================================================

-- Cabecera de Pólizas (Santiago)
CREATE TABLE pv_header (
    id_pv INT PRIMARY KEY,
    cod_suc INT,
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    nro_pol INT,
    aaaa_endoso INT,
    nro_endoso INT,
    cod_aseg INT,
    fec_emi DATE,
    fec_vig_desde DATE,
    fec_vig_hasta DATE,
    cod_tipo_agente INT,
    cod_agente INT REFERENCES dim_agente(cod_agente_principal),
    cod_grupo_endo INT,
    cod_tipo_endo INT,
    cod_grupo INT
);

-- Maestro de Pólizas para Reportes (Gianni)
CREATE TABLE tb_polizas (
    id_poliza INT PRIMARY KEY,
    fecha_inicio_vig DATE,
    fecha_fin_vig DATE,
    cod_sucursal INT,
    sucursal VARCHAR(150),
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    cod_agrupador INT REFERENCES dim_agrupador(cod_agrupador_principal),
    cod_aseg INT,
    nombre_aseg VARCHAR(250),
    apellido_aseg VARCHAR(250),
    cedula VARCHAR(20),
    cod_producto INT,
    producto VARCHAR(250)
);

-- Ítems y Vehículos (Gianni)
CREATE TABLE tb_items (
    cod_item INT PRIMARY KEY,
    id_poliza INT REFERENCES tb_polizas(id_poliza),
    cod_marca INT,
    marca VARCHAR(250),
    cod_modelo INT,
    modelo VARCHAR(250),
    chasis VARCHAR(250),
    placa VARCHAR(50),
    cod_color INT,
    color VARCHAR(150),
    cod_tipo_vh INT,
    tipo_vh VARCHAR(150),
    cod_clase_vh INT,
    clase_vh VARCHAR(150),
    cod_uso INT,
    uso VARCHAR(150),
    anio INT,
    direccion VARCHAR(500)
);

-- Coberturas (Gianni)
CREATE TABLE tb_cobertura (
    cod_cober INT PRIMARY KEY,
    id_poliza INT REFERENCES tb_polizas(id_poliza),
    cod_item INT REFERENCES tb_items(cod_item),
    cobertura VARCHAR(250),
    sn_activo BOOLEAN
);

-- ==============================================================================
-- 3. MÓDULO DE SINIESTROS Y RESERVAS (SANTIAGO)
-- ==============================================================================

-- Cabecera del Siniestro
CREATE TABLE stro_header (
    id_stro INT PRIMARY KEY,
    cod_suc INT,
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    aaaa_ejercicio INT,
    nro_stro VARCHAR(100),
    id_pv INT REFERENCES pv_header(id_pv),
    fec_hora_reclamo DATE,
    fec_aviso DATE,
    fec_registro DATE,
    cod_causa INT REFERENCES tcausa_stro(cod_causa),
    cod_usuario VARCHAR(150)
);

-- Pagos del Siniestro (Cabecera)
CREATE TABLE stro_op_header (
    id_stro_op INT PRIMARY KEY,
    cod_suc INT,
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    nro_aut_tec INT,
    fec_emi DATE,
    fec_pago DATE,
    fec_estim_pago DATE,
    fec_ingreso_contable DATE,
    fec_anul DATE,
    imp_total_pagar NUMERIC(15,2),
    txt_desc TEXT,
    cod_agente INT REFERENCES dim_agente(cod_agente_principal),
    nro_recibo_devengado INT,
    nro_recibo_pago INT,
    nro_op INT,
    cod_movimiento INT,
    txt_cheque_a_nom VARCHAR(250),
    nro_comprobante INT,
    txt_razon_social VARCHAR(250),
    cod_usuario VARCHAR(150),
    txt_reclamante VARCHAR(250)
);

-- Detalle de Pagos
CREATE TABLE stro_op_pagos (
    id_pago SERIAL PRIMARY KEY,
    id_stro_op INT REFERENCES stro_op_header(id_stro_op),
    id_stro INT REFERENCES stro_header(id_stro),
    cod_item INT,
    cod_ind_cob INT,
    cod_tercero INT,
    cod_tipo_pago INT,
    imp_pago NUMERIC(15,2),
    cod_clase_pago INT,
    cod_ramo INT REFERENCES dim_ramo(cod_ramo)
);

-- Reservas/Estimaciones (Cabecera)
CREATE TABLE estim_header (
    id_estim_header SERIAL PRIMARY KEY,
    id_stro INT REFERENCES stro_header(id_stro),
    cod_item INT,
    cod_ind_cob INT,
    txt_bien_strado VARCHAR(250),
    cod_municipio INT REFERENCES tmunicipio(cod_municipio),
    cod_dpto INT REFERENCES tdpto(cod_dpto),
    cod_pais INT REFERENCES tpais(cod_pais),
    id_pv INT REFERENCES pv_header(id_pv),
    cod_ramo INT REFERENCES dim_ramo(cod_ramo)
);

-- Reservas/Estimaciones (Importes)
CREATE TABLE estim_importe (
    id_estim_importe SERIAL PRIMARY KEY,
    id_stro INT REFERENCES stro_header(id_stro),
    cod_item INT,
    cod_ind_cob INT,
    cod_estim INT,
    nro_correla_estim INT,
    fec_estim DATE,
    cod_tipo_estim INT,
    imp_estimado NUMERIC(15,2),
    cod_usuario VARCHAR(150)
);

-- ==============================================================================
-- 4. TABLAS DE HECHOS COMERCIALES (DAVID)
-- ==============================================================================

CREATE TABLE produccion_2026 (
    id_produccion SERIAL PRIMARY KEY,
    cod_tipo_produccion INT,
    tipo_produccion VARCHAR(150),
    anio INT,
    numero_mes INT,
    mes VARCHAR(50),
    fecha DATE,
    sucursal VARCHAR(150),
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    cod_tipo_agente INT,
    tipo_agente VARCHAR(150),
    cod_agente INT REFERENCES dim_agente(cod_agente_principal),
    agente VARCHAR(250),
    poliza INT,
    endoso INT,
    cod_contratante INT,
    contratante VARCHAR(250),
    cod_asegurado INT,
    asegurado VARCHAR(250),
    cedula_asegurado VARCHAR(50),
    fecha_emision DATE,
    vigencia_desde DATE,
    vigencia_hasta DATE,
    canal_emision VARCHAR(150),
    agrupador VARCHAR(150),
    agrupador_principal VARCHAR(150),
    prima NUMERIC(15,2),
    punto_vta VARCHAR(150),
    tipo_endoso VARCHAR(150),
    motivo_endoso VARCHAR(250),
    pertenece_grupo VARCHAR(50),
    pago_inicial VARCHAR(50),
    ejecutivo_comercial VARCHAR(250)
);

CREATE TABLE presupuesto_2026 (
    id_presupuesto SERIAL PRIMARY KEY,
    cod_tipo_produccion INT,
    tipo_produccion VARCHAR(150),
    anio INT,
    numero_mes INT,
    mes VARCHAR(50),
    fecha DATE,
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    cod_tipo_agente INT,
    tipo_agente VARCHAR(150),
    cod_agente INT REFERENCES dim_agente(cod_agente_principal),
    agente VARCHAR(250),
    canal_emision VARCHAR(150),
    agrupador VARCHAR(150),
    agrupador_principal VARCHAR(150),
    presupuesto NUMERIC(15,2),
    punto_vta VARCHAR(150),
    pertenece_grupo VARCHAR(50),
    ejecutivo_comercial VARCHAR(250)
);

CREATE TABLE renovaciones_2026 (
    id_renovacion SERIAL PRIMARY KEY,
    anio INT,
    numero_mes INT,
    mes VARCHAR(50),
    fecha DATE,
    sucursal VARCHAR(150),
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    cod_tipo_agente INT,
    tipo_agente VARCHAR(150),
    cod_agente INT REFERENCES dim_agente(cod_agente_principal),
    agente VARCHAR(250),
    poliza INT,
    endoso INT,
    cod_contratante INT,
    contratante VARCHAR(250),
    cod_asegurado INT,
    asegurado VARCHAR(250),
    cedula_asegurado VARCHAR(50),
    vigencia_desde DATE,
    vigencia_hasta DATE,
    canal_emision VARCHAR(150),
    agrupador VARCHAR(150),
    agrupador_principal VARCHAR(150),
    prima_a_renovar NUMERIC(15,2),
    punto_vta VARCHAR(150),
    ejecutivo_comercial VARCHAR(250),
    estado_renovacion VARCHAR(150)
);

CREATE TABLE kpi_crm (
    id_kpi SERIAL PRIMARY KEY,
    anio INT,
    numero_mes INT,
    mes VARCHAR(50),
    fecha DATE,
    cod_ramo INT REFERENCES dim_ramo(cod_ramo),
    cod_tipo_agente INT,
    tipo_agente VARCHAR(150),
    cod_agente INT REFERENCES dim_agente(cod_agente_principal),
    agente VARCHAR(250),
    canal_emision VARCHAR(150),
    prima_target NUMERIC(15,2),
    punto_vta VARCHAR(150),
    ejecutivo_comercial VARCHAR(250),
    cliente VARCHAR(250),
    quotation VARCHAR(250),
    hit_ratio VARCHAR(50),
    etapa_actual VARCHAR(150),
    estado VARCHAR(150)
);

CREATE TABLE asesores_productores_seguros_scvs (
    id_asesor SERIAL PRIMARY KEY,
    agente VARCHAR(250),
    codigo_super_cias INT,
    ramo VARCHAR(150),
    prima NUMERIC(15,2),
    fecha DATE
);

-- ==============================================================================
-- 5. MÓDULO BANCA SEGUROS / PAGOS MASIVOS (ROBERT)
-- ==============================================================================

CREATE TABLE sabana_polizas_emasivos (
    id_emasivo SERIAL PRIMARY KEY,
    id_cliente VARCHAR(100),
    asegurado VARCHAR(250),
    fecha_emision DATE,
    ramo VARCHAR(150),
    producto VARCHAR(150),
    sucursal VARCHAR(150),
    primer_apellido VARCHAR(150),
    segundo_apellido VARCHAR(150),
    nombres VARCHAR(250),
    prima_neta NUMERIC(15,2)
);

CREATE TABLE oficio_pagos_recurrentes (
    id_oficio SERIAL PRIMARY KEY,
    rfc_titular VARCHAR(50),
    segmento VARCHAR(100),
    tarjeta VARCHAR(100),
    nombres_afiliado VARCHAR(250),
    fecha_venta DATE,
    oficio VARCHAR(100),
    carga VARCHAR(100),
    mes VARCHAR(50),
    valor NUMERIC(15,2),
    estado VARCHAR(100),
    asistencias VARCHAR(250),
    plan VARCHAR(150)
);

CREATE TABLE sabana_pagos_emasivos (
    id_pago_emasivo SERIAL PRIMARY KEY,
    campo_ultimo_mes VARCHAR(50),
    campo_cedula VARCHAR(50),
    campo_forma_pago VARCHAR(150)
);