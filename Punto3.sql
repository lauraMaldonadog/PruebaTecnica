select 
    f.id_factura,
    f.fecha_factura,
    fd.id_medicamento,
    fd.valor_unitario as valor_incorrecto,
    tm.valor_unitario as valor_correcto,
    e.nombre_empresa,
    s.nombre_sede
from 
    fa_facturas f
join 
    fa_factudt fd on f.id_factura = fd.id_factura
join 
    pa_medicamentos m on fd.id_medicamento = m.id_medicamento
join 
    pa_tarifmedi tm on m.id_medicamento = tm.id_medicamento
join 
    pa_sede s on f.id_sede = s.id_sede
join 
    si_empresas e on f.id_empresa = e.id_empresa
where 
    fd.id_medicamento = 12218
    and f.fecha_factura >= to_date('01/02/2022', 'dd/mm/yyyy')
    and fd.valor_unitario != tm.valor_unitario;
