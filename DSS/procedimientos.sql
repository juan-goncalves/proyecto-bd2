create or replace procedure Extraer as
anio_min number := 2016;
anio_max number := 2018;
idForPaisAux number;
idForBodega number;
idForMarca number;
begin
  
  -- TODO: Calcular estas fechas en base de la tabla de tiempoAux
  << anio_loop >>
  for anio in anio_min .. anio_max loop
      
      
      begin
        insert into I_tiempoAux values (anio);
      exception
        when DUP_VAL_ON_INDEX then
          continue;
      end;
      

    
    <<paises_loop>>
    for recPais in (select p.id, p.nombre, p.continente, produccion_pais_en(p.id, anio) prod, CalcularExportacionPais(p.id, anio) exportacion from Pais p)
    loop
        idForPaisAux := seq_Imetricas_pais.nextval;
        DBMS_OUTPUT.PUT_LINE('ID: ' || to_char(idForPaisAux) || ' Nombre Pais: ' || recPais.nombre || ' Prod: ' || to_char(recPais.prod) || ' Exp: ' || to_char(recPais.exportacion));
        INSERT INTO I_paisAux VALUES (idForPaisAux, anio, recPais.nombre, recPais.continente, recPais.prod, recPais.exportacion);
      
        <<bodegas_loop>>
        for recBodega in (
            select distinct bo.id, bo.nombre, produccion_bodega_en(bo.id, anio) prod, exportacion_bodega_en(bo.id, anio) exportacion
            from B_DO bdo, Pais p, Region r, DenominacionDeOrigen do, Bodega bo
            where r.fk_pais = recPais.id
            and do.fk_region = r.id
            and bdo.fk_do_id = do.id
            and bdo.fk_do_region = do.fk_region
            and bdo.fk_do_variedadvid = do.fk_variedadvid
            and bdo.fk_bodega = bo.id  
        ) loop
        
            idForBodega := seq_Icontinente.nextval; -- TODO: Cambiar nombre de secuencia?           
            INSERT INTO I_bodega VALUES (idForBodega, idForPaisAux, anio, recBodega.nombre, recBodega.prod, recBodega.exportacion);

            <<marca_loop>>
            for recMarca in (                
                select distinct M.id, M.nombre, produccion_marca_en(M.id, anio) produccion, exportacion_marca_en(M.id, anio) exportacion, premios_marca_en(M.id, anio) nPremios 
                from MarcaVino M, MarcaVino_B_DO MB,Bodega B 
                where B.id = MB.fk_bodega and M.id = MB.fk_marcavino and B.id = recBodega.id
            ) loop
                DBMS_OUTPUT.PUT_LINE('ID: ' || to_char(recMarca.id) || ' Nombre Marca: ' || recMarca.nombre || ' Prod: ' || to_char(recMarca.produccion) || ' Exp: ' || to_char(recMarca.exportacion) || ' Premios: ' || to_char(recMarca.nPremios));
                idForMarca := seq_Itiempo.nextval; -- TODO: Cambiar nombre de secuencia?
                insert into I_marca values (idForMarca, idForBodega, anio, recMarca.nombre, recMarca.produccion, recMarca.exportacion, recMarca.nPremios);
            
                -- TODO: Extraer criticas

            end loop marca_loop;

        end loop bodegas_loop;

    end loop paises_loop;


    -- TODO: Extraer Concursos y Catadores
  end loop anio_loop;

end;
/

create or replace procedure Limpiar as 
begin   
    delete from I_critica;
    delete from I_marca;
    delete from I_bodega;
    delete from I_paisAux;
    delete from I_concurso;
    delete from I_catador;
end;
/

/*
    Funcion que se encarga de contar el numero de premios para una marca en un año dado.
    Es un wrapper para el query.
*/
create or replace function premios_marca_en(idMarcaOLTP number, anio number)
return number is
    n_premios number;
begin
    select COUNT(*) into n_premios
    from muestraCompite c, marcaVino mv, Inscripcion i
    where mv.id = idMarcaOLTP and c.premio is not empty 
    and mv.id = c.fk_marcavino 
    and i.id = c.fk_inscripcion 
    and EXTRACT(year from i.fecha) = anio;

    return n_premios;
end;
/