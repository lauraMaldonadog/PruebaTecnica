create table usuarios (
    id_usuario number primary key,
    nombre_usuario varchar2(50) not null unique,
    contrasena varchar2(255) not null,
    correo varchar2(100) unique,
    fecha_creacion date default sysdate,
    estado varchar2(10) default 'activo'
);

create sequence seq_usuarios
start with 1
increment by 1
nocache
nocycle;

create or replace procedure gestionusuarios(
    p_accion in varchar2,
    p_id_usuario in number,
    p_nombre_usuario in varchar2,
    p_contrasena in varchar2,
    p_correo in varchar2
)
is
    v_usuario_existe number;
begin
    -- verificar si el usuario existe (para actualizar e inactivar)
    if p_accion in ('actualizar', 'inactivar') then
        select count(*) into v_usuario_existe
        from usuarios
        where id_usuario = p_id_usuario;
    end if;

    case p_accion
        when 'insertar' then
            insert into usuarios (id_usuario, nombre_usuario, contrasena, correo)
            values (seq_usuarios.nextval, p_nombre_usuario, p_contrasena, p_correo);
            dbms_output.put_line('usuario insertado correctamente');

        when 'actualizar' then
            if v_usuario_existe > 0 then
                update usuarios
                set nombre_usuario = nvl(p_nombre_usuario, nombre_usuario),
                    contrasena = nvl(p_contrasena, contrasena),
                    correo = nvl(p_correo, correo)
                where id_usuario = p_id_usuario;
                dbms_output.put_line('usuario actualizado correctamente');
            else
                dbms_output.put_line('usuario no encontrado para actualizar');
            end if;

        when 'inactivar' then
            if v_usuario_existe > 0 then
                update usuarios
                set estado = 'inactivo'
                where id_usuario = p_id_usuario;
                dbms_output.put_line('usuario inactivado correctamente');
            else
                dbms_output.put_line('usuario no encontrado para inactivar');
            end if;

        else
            dbms_output.put_line('acción no válida');
    end case;

    commit;

exception
    when others then
        rollback;
        dbms_output.put_line('error: ' || sqlerrm);
end gestionusuarios;
/

-- habilitar la salida en consola
set serveroutput on;

-- insertar un nuevo usuario
begin
    gestionusuarios('insertar', null, 'nuevo_usuario', 'contrasena123', 'correo@ejemplo.com');
end;
/

-- actualizar un usuario existente
begin
    gestionusuarios('actualizar', 1, 'usuario_actualizado', 'nueva_contrasena', 'nuevo_correo@ejemplo.com');
end;
/

-- inactivar un usuario
begin
    gestionusuarios('inactivar', 1, null, null, null);
end;
/
