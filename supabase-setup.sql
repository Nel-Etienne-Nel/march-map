-- Run this in your Supabase SQL Editor to set up the hotspots table

create table hotspots (
  id bigint generated always as identity primary key,
  province text not null,
  area text not null,
  lat double precision not null,
  lng double precision not null,
  risk text not null check (risk in ('High', 'Medium', 'Low')),
  description text,
  verified boolean not null default false,  -- false = news/public-sourced, awaiting admin review
  source text,                              -- e.g. 'news bot', 'public submission'
  created_at timestamptz default now()
);

-- Allow anyone to read and insert (no auth required)
alter table hotspots enable row level security;

create policy "Public read" on hotspots for select using (true);
create policy "Public insert" on hotspots for insert with check (true);

-- Only the admin account may delete. Enforced server-side regardless of UI.
create policy "Owner delete" on hotspots
  for delete to authenticated
  using ( (auth.jwt() ->> 'email') = 'neletienne18@gmail.com' );

-- Only the admin may update (e.g. flip verified). Enforced server-side.
create policy "Owner update" on hotspots
  for update to authenticated
  using      ( (auth.jwt() ->> 'email') = 'neletienne18@gmail.com' )
  with check ( (auth.jwt() ->> 'email') = 'neletienne18@gmail.com' );

-- Seed with the initial data
insert into hotspots (province, area, lat, lng, risk, description) values
  ('Gauteng','N1 highway corridor',-25.9992,28.1263,'High','Road blockades, freight disruption, commuter delays, opportunistic crime.'),
  ('Gauteng','N3 highway corridor',-26.2500,28.1500,'High','Freight disruption, truck intimidation, access disruption to industrial clients.'),
  ('Gauteng','N12 highway corridor',-26.1800,28.3000,'High','Road disruption, industrial-area spill-over, freight delays.'),
  ('Gauteng','Johannesburg CBD / Newtown / Mary Fitzgerald Square',-26.2023,28.0307,'High','Crowd gathering, traffic disruption, protest spill-over into CBD.'),
  ('Gauteng','Main Reef Road',-26.2070,28.0200,'High','March movement, road closure, disruption near commercial/industrial nodes.'),
  ('Gauteng','China Shopping Centre',-26.2140,28.0120,'High','Direct protest focus, intimidation, shop closure pressure.'),
  ('Gauteng','Dragon City',-26.2100,28.0160,'High','Direct protest focus, intimidation, traffic disruption, crowd-control risk.'),
  ('Gauteng','Hillbrow',-26.1890,28.0470,'High','Xenophobia-linked mobilisation, crowd conflict, ID-check intimidation.'),
  ('KwaZulu-Natal','eThekwini / Durban',-29.8587,31.0218,'High','High crowd activity, intimidation, CBD disruption, business closures.'),
  ('KwaZulu-Natal','uMgungundlovu / Pietermaritzburg',-29.6006,30.3794,'High','Community mobilisation, public-order risk, foreign-national intimidation.'),
  ('KwaZulu-Natal','N3 corridor / Mooi River',-29.2080,29.9940,'High','Truck blockades, freight disruption, cargo risk, driver intimidation.'),
  ('Western Cape','Mossel Bay / KwaNongaba / Asia Park',-34.1700,22.1100,'High','Xenophobic violence risk, arson, displacement, retaliation.'),
  ('Western Cape','Kleinmond',-34.3400,19.0250,'High','Community unrest, displacement, intimidation, property damage.'),
  ('Western Cape','Gansbaai',-34.5830,19.3510,'High','Community unrest, intimidation, displacement, business closures.'),
  ('Eastern Cape','KuGompo / East London',-32.9833,27.8667,'High','Anti-foreign-national mobilisation, business sackings, looting risk.'),
  ('Northern Cape','Kimberley',-28.7282,24.7499,'Low','Localised protest, access disruption, isolated intimidation.'),
  ('Northern Cape','N12 / N14 corridors',-28.5300,24.7300,'Low','Route delays, logistics disruption, isolated road incidents.'),
  ('Gauteng','N4 highway corridor',-25.7420,28.2920,'Medium','Road closures, logistics delays, spill-over protest activity.'),
  ('Gauteng','Benoni / Actonville / Wattville',-26.1885,28.3208,'Medium','Localised mobilisation, foreign-owned shop intimidation, route disruption.'),
  ('Gauteng','OR Tambo / Isando / Kempton Park logistics',-26.1337,28.2420,'Medium','Cargo delay, staff access disruption, industrial spill-over.'),
  ('Gauteng','Pretoria / Tshwane CBD',-25.7479,28.2293,'Medium','Government-facing protest, CBD traffic disruption, commuter impact.'),
  ('KwaZulu-Natal','Eshowe',-28.8865,31.4699,'Medium','Localised protest, business intimidation, access disruption.'),
  ('Western Cape','Cape Agulhas / Bredasdorp anchor',-34.5322,20.0403,'Medium','Rural-town unrest, intimidation, isolated property damage.'),
  ('Western Cape','Cape Town metro',-33.9189,18.4233,'Medium','Flash mobilisation, transport disruption, copycat action.'),
  ('Eastern Cape','Thornhill / Gqeberha surrounds',-33.9050,25.0940,'Medium','Localised protest, road obstruction, vulnerable community intimidation.'),
  ('North West','Rustenburg',-25.6676,27.2421,'Medium','Mining-town disruption, worker movement interference, road blockades.'),
  ('North West','Marikana',-25.6970,27.4870,'Medium','Community mobilisation, labour-route disruption, intimidation.'),
  ('North West','Brits',-25.6347,27.7802,'Medium','Road disruption, shop closure pressure, corridor spill-over.'),
  ('North West','Klerksdorp',-26.8521,26.6667,'Medium','Localised protest, CBD disruption, retail/trading intimidation.'),
  ('North West','Potchefstroom',-26.7145,27.0970,'Medium','Localised protest, traffic disruption, retail impact.'),
  ('North West','N4 / R566 corridors',-25.6400,27.8500,'Medium','Road blockades, logistics delays, spill-over from Gauteng mobilisation.'),
  ('Limpopo','Polokwane',-23.9045,29.4689,'Medium','Localised protest, commuter disruption, retail impact.'),
  ('Limpopo','Musina / Beitbridge corridor',-22.3488,30.0407,'Medium','Border-route delays, freight disruption, intimidation of foreign nationals.'),
  ('Mpumalanga','Mbombela / N4 corridor',-25.4753,30.9694,'Medium','Freight delays, localised protest, road obstruction.'),
  ('Mpumalanga','Komatipoort / Lebombo border route',-25.4300,31.9540,'Medium','Border-route disruption, truck delays, spill-over intimidation.'),
  ('Free State','Bloemfontein / Mangaung',-29.0852,26.1596,'Medium','CBD disruption, commuter impact, copycat action.'),
  ('Free State','N1 / N3 connector routes / Harrismith approach',-28.2720,29.1290,'Medium','Transit disruption, freight delay, isolated blockade risk.');

-- Mark the official seed as verified
update hotspots set verified = true;
