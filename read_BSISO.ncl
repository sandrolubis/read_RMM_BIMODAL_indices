data = asciiread("BSISO_25-90bpfil_pc.extension.txt",(/15556,8/),"float")

;creating time dimension from the original file

strt    = 19790322
last    = 20211022

  year   = tointeger(data(:,0))
  month  = tointeger(data(:,1))
  day    = tointeger(data(:,2))
  hour   = tointeger(data(:,1))
  minute = tointeger(data(:,1))
  second = tointeger(data(:,1))

  hour   = 0
  minute = 0
  second = 0

  units  = "days since 1970-01-01 00:00:00"

  time = cd_inv_calendar(year,month,day,hour,minute,second,units, 0)
  ;print(date)

  date = cd_calendar(time, 2) 
  time!0="time"

;;;;;;;;;  Select the period of interest ;;;;;;;;

istrt    = ind(date.eq.19800101)      ; change here start date
ilast    = ind(date.eq.20201231)      ; change here end date


phase 	    = data(istrt:ilast,5)
amp           = data(istrt:ilast,6)
time_select = time(istrt:ilast)

ntim=dimsizes(time_select)

events = new((/8, ntim/), integer)

events!0 = "phase"
events!1 = "time"
events&phase = ispan(1, 8, 1)
events&time = time_select
events@_FillValue = 999
printVarSummary(events) 

;Checking for any missing values to make sure everything is alright
if(any(ismissing(amp))) then
    print("Your amplitude data contains some missing values. Beware.")
  end if

if(any(ismissing(phase))) then
      print("Your phase data contains some missing values. Beware.")
  end if


events = 0

do i = 0, ntim-1
  if(amp(i).gt.1. .and. phase(i).eq.1) then
    events(0,i) = 1
  end if
  if(amp(i).gt.1. .and. phase(i).eq.2) then
    events(1,i) = 1
    end if
  if(amp(i).gt.1. .and. phase(i).eq.3) then
    events(2,i) = 1
    end if
  if(amp(i).gt.1. .and. phase(i).eq.4) then
    events(3,i) = 1
    end if
  if(amp(i).gt.1. .and. phase(i).eq.5) then
    events(4,i) = 1
    end if
  if(amp(i).gt.1. .and. phase(i).eq.6) then
    events(5,i) = 1
    end if
  if(amp(i).gt.1. .and. phase(i).eq.7) then
    events(6,i) = 1
    end if
  if(amp(i).gt.1. .and. phase(i).eq.8) then
    events(7,i) = 1
    end if
  end do


printVarSummary(events)

;;;; Save output in netcdf ;;;;

system("rm bimodal.index.nc")
fout = addfile("bimodal.index.nc", "c")
fout->events = events


