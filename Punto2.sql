----------------------------------- 2.1 -------------------------------------------------


select c.nombre, c.telefono, c.ciudad
from clientes c
join compras co ON c.idcliente = co.cliente
join productos_compras pc ON co.idcompra = pc.compra
where c.ciudad = 'ARMENIA'
  and to_char(co.FECHA, 'YYYY-MM') = '2022-12'
group by  c.nombre, c.telefono, c.ciudad
having sum(pc.total) > 10000000;

-------------------------------------- 2.2 -----------------------------------------------

select c.nombre, c.telefono, c.ciudad
from clientes c
join compras co on c.idcliente =co.cliente
join productos_comoras pc on co.idcompra = pc.compra
join productos p on pc.producto = p.idprod
where p.descripcion like '%tv%'
and pc.cantidad>2
group by c.nombre, c.telefono, c.ciudad ;

--------------------------------- 2.3 ----------------------------------------------

select *
from (
select c.nombre, c.telefono, c.ciudad, 
sum(pc.cantidad) as total_productos, 
sum(pc.TOTAL) as total_compras
from clientes c
join compras co on c.idcliente = co.cliente
join productos_compras pc on co.idcompra = pc.compra
group by c.nombre, c.telefono, c.ciudad
having sum(pc.total) > 100000000
order by sum(pc.total) desc
) 
where rownum <= 5;