ALTER SESSION SET CURRENT_SCHEMA = WINE_SCHEMA;

/* Definicion de TDAs */

create or replace type tipo_valor as object (
    anio number(4, 0),
    valor number,
    unidad varchar2(30)
);
/
create or replace type distribucion_exp as object (
    tipoValor tipo_valor,
    pais varchar2(50)
);
/
CREATE OR REPLACE TYPE valoracion as object (
    nombreElemento varchar2(50),
    valor number,
    observacion varchar2(100)
);
/
CREATE OR REPLACE TYPE lugar as object (
    ciudad varchar2(50),
    pais varchar2(50)
);
/
CREATE OR REPLACE TYPE hechos_hist as object (
    anio number(10),
    hechos varchar2(100)
);
/
CREATE OR REPLACE TYPE valoracion_nt as TABLE OF valoracion;
/
CREATE OR REPLACE TYPE publicaciones_nt as TABLE OF varchar2(50);
/
CREATE OR REPLACE TYPE hechos_hist_nt as TABLE OF hechos_hist;
/
-- TODO: Decidir size del varray
create or replace type conj_telefonos is varray(5) of number(14);
/
create or replace type direccion as object (
    estado varchar2(100),
    codigoPostal varchar2(15),
    lineaDireccion1 varchar2(100),
    lineaDireccion2 varchar2(100)
);
/
create or replace type personaDeContacto as object (
    nombre varchar2(50),
    apellido varchar2(50),
    cargo varchar2(50),
    email varchar2(50)
);
/
-- TODO: Borrar esta NT, deberia ser un varray
create or replace type personasDeContacto_nt as table of personaDeContacto;
/

create or replace type datosDeContacto as object (
    telefonos conj_telefonos,
    fax number(14),
    email varchar2(50),
    direccionWeb varchar2(100),
    dir direccion--,
    -- TODO: Poner varray
    -- personasDeContacto personasDeContacto_nt
);
/
create or replace type tipo_valor_nt as table of tipo_valor;
/
create or replace type distribucion_exp_nt as table of distribucion_exp;
/
create or replace type premio as object(
    nombre varchar2(50),
    posicion number(10),
    descripcion varchar2(200),
    tipo varchar2(10),
    premioMoneda number(20)
);
/
create or replace type premio_nt as table of premio;
/
create or replace type escala as object(
    elemento varchar2(20),
    rangoInferior number(5),
    rangoSuperior number(5),
    clasificacion varchar2(20)
);
/
create or replace type escala_nt as table of escala;
/
create or replace type costoInscripcion as object(
    nroDeMuestras number(10),
    valor number(20),
    unidadValor varchar2(50),
    pais varchar2(50)
);
/
create or replace type costoInscripcion_nt as table of costoInscripcion;
/
create or replace type datosBancarios as object(
    recipiente varchar2(50),
    nombreBanco varchar2(50),
    codigoCuenta varchar2(50),
    codigoSucursal varchar2(50)
);
/
create or replace type unidadMonetaria as object(
    nombre varchar2(50),
    simbolo varchar2(5)
);
/
CREATE OR REPLACE DIRECTORY mapas_regionales AS 'C:\WINE_DB\mapas_regionales';

/* Creacion de tablas */
-- Tablas Juan
CREATE TABLE Pais (
    id number,
    nombre varchar2(50) not null,
    continente varchar2(9) not null CHECK (continente IN ('Asia', 'Europa', 'África', 'América', 'Oceanía', 'Antártida')),
    superficieVinedo tipo_valor_nt,
    produccionAnual tipo_valor_nt,
    exportacionAnual distribucion_exp_nt,
    unidadMonetaria unidadMonetaria not null,
    mapaRegional BFILE not null,
    descripcion varchar2(200),
    constraint pk_pais primary key (id)
)
NESTED TABLE superficieVinedo STORE AS superficieVinedo_nt_pais,
NESTED TABLE produccionAnual STORE AS produccionAnual_nt_pais,
NESTED TABLE exportacionAnual STORE AS exportacionAnual_nt_pais;
/
create table Region (
    id number,
    nombre varchar2(50) not null,
    descripcion varchar2(100),
    FK_Pais number not null,
    constraint pk_region primary key (id)
);
/
create table VariedadVid (
    id number(10),
    nombre varchar2(50) not null,
    tipo varchar2(6) check (tipo in ('tinta','blanca')) not null,
    constraint pk_variedadvid primary key (id)
);
/
create table DenominacionDeOrigen (
    id number(10),
    nombre varchar2(50) not null,
    descripcion varchar2(250),
    FK_VariedadVid number(10),
    FK_Region number,
    constraint pk_denominacion_de_origen primary key (id, FK_VariedadVid, FK_Region)
);
/
create table Bodega (
    id number(10),
    nombre varchar2(50) not null,
    historia hechos_hist_nt,
    fechaFundacion date not null,
    datosDeContacto datosDeContacto not null,
    descripcionMision varchar2(200) not null,
    descripcionGeneralVinos varchar2(200) not null,
    produccionAnual tipo_valor_nt,
    exportacionAnual distribucion_exp_nt,
    propietario number,
    constraint pk_bodega primary key (id)
)
NESTED TABLE historia STORE AS historia_nt_bodega,
NESTED TABLE produccionAnual STORE AS produccionAnual_nt_bodega,
NESTED TABLE exportacionAnual STORE AS exportacionAnual_nt_bodega;
--NESTED TABLE datosDeContacto.personasDeContacto STORE AS personasDeContacto_nt_bodega;
/

create table B_DO (
    id number,
    -- PK de DenominacionDeOrigen --
    fk_do_id number(10),
    fk_do_VariedadVid number(10),
    fk_do_region number(10),
    --------------------------------
    fk_bodega number(10),
    constraint pk_B_DO primary key (id, fk_do_id, fk_do_VariedadVid, fk_do_region, fk_bodega)
);
/
create table Cosecha (
    id number,
    anio number(4, 0) not null,
    clasificacion varchar2(2) not null,
    -- PK de B_DO ------------------------
    fk_bdo_id number,
        -- PK de DenominacionDeOrigen --
        fk_bdo_do_id number(10),
        fk_bdo_do_VariedadVid number(10),
        fk_bdo_do_region number(10),
        --------------------------------
        -- PK de Bodega ----------------
        fk_bdo_bodega number(10),
        --------------------------------
    --------------------------------------
    constraint clasificacion_valida check (clasificacion in ('E', 'MB', 'R', 'D')),
    constraint pk_cosecha primary key (id, fk_bdo_id, fk_bdo_do_id, fk_bdo_do_VariedadVid, fk_bdo_do_region, fk_bdo_bodega)
);

-- Tablas Cagua
/
CREATE TABLE CatadorAprendiz(
    pasaporte number,
    nombre varchar2(50) NOT NULL,
    apellido varchar2(50) NOT NULL,
    fechaDeNacimiento date NOT NULL,
    genero varchar2(1) NOT NULL,
    lugarNacimiento lugar,
    CONSTRAINT tipo_genero CHECK (genero in ('M','F','O')),
    CONSTRAINT pk_catadoraprendiz PRIMARY KEY (pasaporte)
);
/
CREATE TABLE CataAprendiz (
    id number,
    fecha date NOT NULL,
    valoraciones valoracion_nt,
    sumatoria number(20) NOT NULL,
    fk_catadoraprendiz number,
    fk_muestra number,
    CONSTRAINT pk_cataaprendiz PRIMARY KEY (id)
)
NESTED TABLE valoraciones STORE AS valoracion_nt_1;
/
CREATE TABLE CatadorExperto (
    id number,
    nombre varchar2(50) NOT NULL,
    apellido varchar2(50) NOT NULL,
    fechaDeNacimiento date NOT NULL,
    descripcion varchar2(100),
    hechosCurriculum hechos_hist_nt,
    lugarNacimiento lugar,
    publicaciones publicaciones_nt,
    genero varchar2(1) NOT NULL,
    fk_pais number NOT NULL,
    CONSTRAINT tipo_genero_CE CHECK (genero in ('M','F','O')),
    CONSTRAINT pk_catadorexperto PRIMARY KEY (id)
)
NESTED TABLE hechosCurriculum STORE AS hechosCurriculum_nt_1,
NESTED TABLE publicaciones STORE AS publicaciones_nt_1;
/
CREATE TABLE CataExperto (
    id number,
    fecha date NOT NULL,
    valoraciones valoracion_nt,
    sumatoria number(20) NOT NULL,
    fk_catadorexperto number,
    fk_muestracompite number,
    CONSTRAINT pk_cataexperto PRIMARY KEY (id)
)
NESTED TABLE valoraciones STORE AS valoracion_nt_2;
/
/* TODO: Faltan los contrainsts de Foreign key */
CREATE TABLE Juez (
    id number,
    fk_catadorexperto number,
    fk_edicion number,
    CONSTRAINT pk_juez PRIMARY KEY (id, fk_catadorexperto, fk_edicion)
);
/
CREATE TABLE Concurso (
    id number,
    nombre varchar2(50) NOT NULL,
    datosDeContacto datosDeContacto,
    tipoDeCata varchar2(20) NOT NULL,
    deCatadores varchar2(2),
    premios premio_nt,
    escalas escala_nt,
    caracteristicas varchar2(200),
    CONSTRAINT pk_concurso PRIMARY KEY (id)
)
NESTED TABLE premios STORE AS premio_nt_1,
NESTED TABLE escalas STORE AS escala_nt_1;
/
CREATE TABLE Organizador (
    id number,
    nombre varchar2(50) NOT NULL,
    descripcion varchar2(200),
    CONSTRAINT pk_organizador PRIMARY KEY(id)
);
/
CREATE TABLE Organizador_Concurso (
    id number,
    fk_organizador number NOT NULL,
    fk_concurso number NOT NULL,
    CONSTRAINT pk_organizador_concurso PRIMARY KEY(id,fk_organizador,fk_concurso)
);
/
CREATE TABLE P_O (
    id number,
    fk_organizador number NOT NULL,
    fk_pais number NOT NULL,
    CONSTRAINT pk_p_o PRIMARY KEY (id,fk_organizador,fk_pais)
);
/
CREATE TABLE Edicion(
    id number,
    datosBancarios datosBancarios,
    fechaLimiteEnvioDeInscripcion date NOT NULL,
    fechaLimiteRecepcionVinos date,
    fechaInicio date NOT NULL,
    fechaFin date NOT NULL,
    precioEstandarPorMuestra number(10),
    direccionEnvioMuestras direccion NOT NULL,
    costos costoInscripcion_nt,
    lugarRealizar lugar NOT NULL,
    unidadMonetaria unidadMonetaria NOT NULL,
    emailEnvioInscripcion varchar2(50),
    datosDeContacto datosDeContacto NOT NULL,
    fk_concurso number NOT NULL,
    CONSTRAINT pk_edicion PRIMARY KEY (id)
)
NESTED TABLE costos STORE AS costoInscripcion_nt_1;
/
CREATE TABLE Inscripcion (
    id number,
    fecha date NOT NULL,
    premioCatador varchar2(50),
    fk_edicion number NOT NULL,
    fk_bodega number,
    fk_catadoraprendiz number,
    CONSTRAINT pk_inscripcion PRIMARY KEY (id)
);
/
