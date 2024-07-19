-- CS4400: Introduction to Database Systems, Summer 2024
-- Project Phase 3: Database Creation
-- Spencer Banko, Aadarsh Battula, Steven Li, Ronald Zhang

set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'sams';


drop database if exists sams;
create database if not exists sams;
use sams;

create table airline (
  airlineID char(50),
  revenue decimal(12, 0),
  primary key (airlineID)
) engine = innodb;

create table location (
  locID char(50),
  primary key (locID)
) engine = innodb;

create table airplane (
  airlineID char(50),
  tail_num char(50),
  seat_cap decimal(4, 0),
  speed decimal(4, 0),
  locID char(50),
  plane_type char(100),
  skids decimal(2, 0),
  props decimal(2, 0),
  num_engines decimal(2, 0),
  primary key (airlineID, tail_num),
  foreign key (airlineID) references airline(airlineID),
  foreign key (locID) references location(locID)
) engine = innodb;

create table airport (
  airportID char(3),
  airport_name char(100),
  city char(100),
  state char(100),
  country char(100),
  locID char(50),
  primary key (airportID),
  foreign key (locID) references location(locID)
) engine = innodb;

create table leg (
  legID char(50),
  distance decimal(5, 0),
  departure char(3) not null,
  arrival char(3) not null,
  primary key (legID),
  foreign key (departure) references airport(airportID),
  foreign key (arrival) references airport(airportID)
) engine = innodb;

create table route (
  routeID char(50),
  primary key (routeID)
) engine = innodb;

create table route_path (
  routeID char(50),
  legID char(50),
  sequence char(100), -- wtf is the data type of this
  
  primary key (sequence), -- check the note on the bottom idk what it rly means
  foreign key (routeID) references route(routeID),
  foreign key (legID) references leg(legID)
) engine = innodb;

create table flight (
  flightID char(50),
  routeID char(50) not null,
  support_airline char(50),
  support_tail char(50),
  progress decimal(5, 0),
  flight_status enum('on_ground', 'in_flight'), -- idk if this is what they want
  next_time datetime,
  cost decimal(5, 0),

  primary key (flightID),
  foreign key (routeID) references route(routeID),
  foreign key (support_airline, support_tail) references airplane(airlineID, tail_num)
) engine = innodb;