class Log{
	constructor(name){
		_name = name;
		_path = format("database/logs/%s", _name);

		local file = io.file(_path, "r");
		if(!file.isOpen){
			file = io.file(_path, "w");
			if(file.isOpen){
				file.write(format("[%s] Created %s", get8601Date(), _name));
				file.close();
			}else error(file.errorMsg);
		}else error(file.errorMsg);
	}

	function enter(string){
		local file = io.file(_path, "r+")
		if(file.isOpen){
			file.read(io_type.ALL);
			file.write(format("\n[%s] %s", get8601Date(), string));
			print(string);
			file.close();
		}else error(file.errorMsg);
	}

	function archive(){
		local file = io.file(_path, "r");
		if(file.isOpen){
			buffer = file.read(io_type.ALL);
			file.close();
			file = io.file(format("database/logs/archive/%s%d", _name, time()), "w");
			if(file.isOpen){
				file.write(buffer);
				file.close();
				file = io.file(_path, "w");
				if(file.isOpen){
					file.write(format("[%s] Created %s", get8601Date(), _name));
					file.close();
				}else error(file.errorMsg);
			}else error(file.errorMsg);
		}else error(file.errorMsg);
	}
	_name = null;
	_path = null;
}
