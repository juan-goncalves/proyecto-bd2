CREATE SEQUENCE seq_pais
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
 CREATE SEQUENCE seq_tiempo
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
 CREATE SEQUENCE seq_tipo_concurso
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
 CREATE SEQUENCE seq_metricas_pais
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
 CREATE SEQUENCE seq_metricas_concurso
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOCYCLE;
/
create table DW_metricas_pais (
    id number (10),
    id_tiempo number(10),
    id_lugar number(10),
    id_continente number(10),
    PorcentajeCrecimiento_prod number (3),
    top1_productor_mundial varchar2(50),
    top2_productor_mundial varchar2(50),
    top3_productor_mundial varchar2(50),
    top1_bodega_prod number,
    top2_bodega_prod number,
    top1_exportador varchar2(50),
    top2_exportador varchar2(50),
    top3_exportador varchar2(50),
    top1_marcavino_totalprod varchar2(50),
    top2_marcavino_totalprod varchar2(50),
    top3_marcavino_totalprod varchar2(50),
    top4_marcavino_totalprod varchar2(50),
    top5_marcavino_totalprod varchar2(50),
    top1_marcas_criticas varchar2(50),
    top2_marcas_criticas varchar2(50),
    top3_marcas_criticas varchar2(50),
    constraint DW_metricas_pais primary key (id)
);
/
create table DW_metricas_concurso (
    id number (10),
    id_tipo_concurso number(10),
    id_tiempo number(10),
    id_lugar number(10),
    id_continente number(10),
    PorcentajeCrecimiento_TipoConcurso number(3),
    top1_marca_premios varchar(50),
    top2_marca_premios varchar(50),
    top3_marca_premios varchar(50),
    top1_catador varchar(50),
    top2_catador varchar(50),
    top3_catador varchar(50),
    top_concursoCatadores varchar(50),
    constraint DW_metricas_concurso primary key (id)
);
/
create table DW_tiempo (
    id number (10),
    anio date,
    bienio number (1) not null,
    constraint DW_tiempo primary key (id)
);
/
create table DW_pais (
    id number (10),
    nombre varchar(50) not null,
    continente varchar(50) not null,
    fecha_creacion date not null,
    constraint DW_pais primary key (id)
);
/
create table DW_continente (
    id number (10),
    nombre varchar(50) not null unique,
    fecha_creacion date not null,
    constraint DW_continente primary key (id)
)
/
create table DW_tipo_concurso (
    id number (10),
    nombre varchar(50) not null,
    fecha_creacion date not null,
    constraint DW_tipoConcurso primary key (id)
);
/
