SET SERVEROUTPUT ON;
SET VERIFY OFF;

ACCEPT idCataa PROMPT 'Ingrese la cata a la que pertenece la valoracion: ';
ACCEPT nombre PROMPT 'Ingrese el nombre del tipo de valoracion: ';
ACCEPT valor PROMPT 'Ingrese el valor dado a la muestra: ';
ACCEPT observacion PROMPT 'Ingrese la observacion dada a la cata: ';

declare
    idCata number := &idCataa;
begin
    insertar_valoracion_aprendiz(idCata, '&nombre', &valor, '&observacion');
end;
/

SET VERIFY ON;
