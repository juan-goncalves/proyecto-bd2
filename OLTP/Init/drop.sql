ALTER SESSION SET CURRENT_SCHEMA=WINE_SCHEMA;

drop type tipo_valor force;
drop type distribucion_exp force;
drop type tipo_valor_nt force;
drop type distribucion_exp_nt force;
drop type valoracion force;
drop type hechos_hist force;
drop type lugar force;
drop type conj_telefonos force;
drop type direccion force;
drop type personaDeContacto force;
drop type personasDeContacto force;
drop type datosDeContacto force;
drop type premio force;
drop type escala force;
drop type costoInscripcion force;
drop type datosBancarios force;
drop type unidadMonetaria force;
drop type valoracion_nt force;
drop type publicaciones_nt force;
drop type hechos_hist_nt force;
drop type premio_nt force;
drop type escala_nt force;
drop type costoInscripcion_nt force;
drop type calificacion force;
drop type calificacion_nt force;
drop type maridajes force;
drop type rangoPorcentajeVol force;

drop table CatadorAprendiz cascade constraints purge;
drop table CataAprendiz cascade constraints purge;
drop table CatadorExperto cascade constraints purge;
drop table Pais cascade constraints purge;
drop table Region cascade constraints purge;
drop table Bodega cascade constraints purge;
drop table B_DO cascade constraints purge;
drop table CataExperto cascade constraints purge;
drop table Concurso cascade constraints purge;
drop table Edicion cascade constraints purge;
drop table Inscripcion cascade constraints purge;
drop table Juez cascade constraints purge;
drop table Organizador cascade constraints purge;
drop table Organizador_Concurso cascade constraints purge;
drop table P_O cascade constraints purge;
drop table Cosecha cascade constraints purge;
drop table VariedadVid cascade constraints;
drop table DenominacionDeOrigen cascade constraints;
drop table MuestraCompite cascade constraints purge;
drop table HistoricoPrecio cascade constraints purge;
drop table Presentacion cascade constraints purge;
drop table MarcaVino_B_DO cascade constraints purge;
drop table ClasificacionVinos cascade constraints purge;
drop table MarcaVino cascade constraints purge;
drop table MuestraCatador cascade constraints purge;
drop sequence ids_seq;
