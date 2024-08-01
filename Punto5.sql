create or replace function manipularusuarios(
    p_accion in varchar2
) return sys_refcursor
is
    v_resultado sys_refcursor;
    v_promedio_dias number;
    v_total_usuarios number;
    v_registros_eliminados number;
    v_error_message varchar2(4000);
begin
    case p_accion
        when 'listar' then
            -- devolver todos los registros de la tabla
            open v_resultado for
                select * from usuarios;
        
        when 'calcular_estadisticas' then
            -- calcular el promedio de días desde la creación de las cuentas y el total de usuarios
            select avg(sysdate - fecha_creacion), count(*)
            into v_promedio_dias, v_total_usuarios
            from usuarios
            where estado = 'activo';
            
            open v_resultado for
                select 'promedio de días desde creación' as metrica, 
                       to_char(round(v_promedio_dias, 2)) as valor
                from dual;
        
        when 'borrar' then
            -- borrar todos los registros de la tabla
            delete from usuarios;
            v_registros_eliminados := sql%rowcount;
            commit;
            
            open v_resultado for
                select 'registros eliminados: ' || to_char(v_registros_eliminados) as resultado from dual;
        
        else
            open v_resultado for
                select 'acción no válida' as resultado from dual;
    end case;
    
    return v_resultado;

exception
    when others then
        rollback;
        v_error_message := substr(dbms_utility.format_error_stack || dbms_utility.format_error_backtrace, 1, 4000);
        open v_resultado for
            select 'ocurrió un error durante la ejecución.' as resultado from dual;
        return v_resultado;
end manipularusuarios;
/

---------------------------------------------FUNCIONAMIENT0 -----------------------------------------
---- Prueba acción calcular 
declare
    v_cursor sys_refcursor;
    v_usuario usuarios%rowtype;
begin
    -- llamada a la función con la acción 'listar'
    v_cursor := manipularusuarios('listar');

    -- iterar sobre el cursor y mostrar los resultados
    loop
        fetch v_cursor into v_usuario;
        exit when v_cursor%notfound;
        dbms_output.put_line('id: ' || v_usuario.id_usuario || ', nombre: ' || v_usuario.nombre_usuario || ', correo: ' || v_usuario.correo || ', fecha creación: ' || v_usuario.fecha_creacion || ', estado: ' || v_usuario.estado || ', fecha nacimiento: ' || v_usuario.fecha_nacimiento);
    end loop;

    close v_cursor;
end;
/
--------- Prueba accion calcular estadisticas -----------------------------
declare
    v_cursor sys_refcursor;
    v_resultado varchar2(4000);
begin
    -- llamada a la función con la acción 'calcular_estadisticas'
    v_cursor := manipularusuarios('calcular_estadisticas');

    -- iterar sobre el cursor y mostrar los resultados
    loop
        fetch v_cursor into v_resultado;
        exit when v_cursor%notfound;
        dbms_output.put_line(v_resultado);
    end loop;

    close v_cursor;
end;
/



--------------------------- prueba accion borrar ------------------------

declare
    v_cursor sys_refcursor;
    v_resultado varchar2(4000);
begin
    -- llamada a la función con la acción 'borrar'
    v_cursor := manipularusuarios('borrar');

    -- iterar sobre el cursor y mostrar los resultados
    loop
        fetch v_cursor into v_resultado;
        exit when v_cursor%notfound;
        dbms_output.put_line(v_resultado);
    end loop;

    close v_cursor;
end;
/


