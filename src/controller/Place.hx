package controller;
import sugoi.form.Form;

class Place extends Controller
{

	public function new()
	{
		super();
		
	}
	
	@tpl('place/view.mtt')
	function doView(place:db.Place) {
		view.place = place;
		
		//build adress for google maps
		var addr = "";
		if (place.address1 != null)
			addr += place.address1;
			
		if (place.address2 != null) {
			addr += ", " + place.address2;
		}
		
		if (place.zipCode != null) {
			addr += " " + place.zipCode;
		}
		
		if (place.city != null) {
			addr += " " + place.city;
		}
		
		view.addr = view.escapeJS(addr);
		
	}
	
	@tpl('form.mtt')
	function doEdit(d:db.Place) {
		
		var f = sugoi.form.Form.fromSpod(d);
		
			
		if (f.isValid()) {
		
			f.toSpod(d); 
			d.amap = app.user.amap;
			d.update();
			throw Ok('/contractAdmin',t._("this place has been updated"));
		}
		
		view.form = f;
		view.title = t._("Edit a place");
	}
	
	@tpl("form.mtt")
	public function doInsert() {
		
		var d = new db.Place();
		var f = sugoi.form.Form.fromSpod(d);
		
		if (f.isValid()) {
			f.toSpod(d); 
			d.amap = app.user.amap;
			d.insert();
			throw Ok('/contractAdmin',t._("The place has been registred") );
		}
		
		view.form = f;
		view.title = t._("Register a new delivery place");
	}
	
	public function doDelete(p:db.Place) {
		if (!app.user.isAmapManager()) throw "forbidden";
		if (checkToken()) {
			
			if (db.Distribution.manager.search($placeId == p.id).length > 0) 
				throw Error('/contractAdmin', t._("You can't delete this place because one or more distributions are linked to this place.") );
			
			p.lock();
			p.delete();
			throw Ok("/contractAdmin", t._("Place deleted") );
		}
		
	}
	
	
	
}