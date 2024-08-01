create or replace function contar_pacientes_activos(
    p_fecha_inicio date default null,
    p_fecha_fin date default null
) return number
is
    v_cantidad number;
    
    begin
    
    select * count(*)
    into v_cantidad
    from pacientes p
    where p.estado = 'ACTIVO'
    and (p_fecha_inicio is null or p.fechacreacion >= p_fecha_inicio)
    and (p_fecha_fin is null or p.fechacreacion <= p_fecha_fin);
    
    
    DBMS_OUTPUT.PUT_LINE ('informe de pacientes activos: ' )  
    
    for paciente in (
        select p.nombre1 || ' ' || nvl(p.nombre2, '') || ' ' || 
               p.apellido1 || ' ' || nvl(p.apellido2, '') as nombre_completo,
               p.fechacreacion
        from pacientes p
        where p.estado = 'ACTIVO'
          and (p_fecha_inicio is null or p.fechacreacion >= p_fecha_inicio)
          and (p_fecha_fin is null or p.fechacreacion <= p_fecha_fin)
        order by p.fechacreacion
    ) loop
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || paciente.nombre_completo || 
                             ', Fecha de Creación: ' || to_char(paciente.FECHACREACION, 'DD/MM/YYYY'));
    end loop;
    
     DBMS_OUTPUT.PUT_LINE('Total de pacientes activos: ' || v_cantidad);
     
     return v_cantidad;
     end;
     /
    
    