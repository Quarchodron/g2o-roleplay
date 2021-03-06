dialog <- {
	active = null
	texture = Texture(0, 0, 500, 500, "DLG_CONVERSATION.TGA")
	draw = {}
	text = {}
	maxPosition = 4
	drawPosition = 0
	position = 0
}

// 7 - drawPos 3

function dialog::create(id, ...){
	if(active!=null) destroy();
	setFreeze(true);
	draw[0] <- Draw(0, 0, "QWERTYUIOPASDFGHJKLZXCVBNM");

	local textureHeight = 0,
	textureY = getResolution().y/2-textureHeight,
	drawHeight = draw[0].heightPx;

	if(vargv.len()>=maxPosition) textureHeight = drawHeight*maxPosition;
	else textureHeight = drawHeight*vargv.len();

	draw.rawdelete([0]);
	texture.setPositionPx(0, textureY);
	texture.setSizePx(getResolution().x, textureHeight);
	texture.visible = true;

	local longestDraw = 0;

	for(local i = 0; i<vargv.len(); ++i){
		text[i] <- vargv[i];
		if(i<maxPosition){
			draw[i] <- Draw(0, 0, vargv[i]);
			if(draw[i].widthPx>longestDraw) longestDraw = draw[i].widthPx;
		}
	}

	local resolutionXHalf = (getResolution().x/2)-(longestDraw/2);
	for(local i = 0; i<draw.len(); ++i){
		draw[i].setPositionPx(resolutionXHalf, texture.getPositionPx().y+(drawHeight*i));
		draw[i].visible = true;
	}

	draw[0].setColor(255, 255, 0);
	active = id;
}

function dialog::destroy(){
	texture.visible = false;
	for(local i = 0; i<draw.len(); ++i){
		draw[i].visible = false;
	}
	if(position!=0 && position<maxPosition) draw[position].setColor(255, 255, 255);
	drawPosition = 0;
	position = 0;
	draw.clear();
	text.clear();
	active = null;
	setFreeze(false);
}

function dialog::switcher(select){
	draw[drawPosition].setColor(255, 255, 255);
	if(select){
		position++;
		if(drawPosition<(maxPosition-1)) drawPosition++;
		else if(position>=maxPosition && drawPosition==(maxPosition-1)){
			for(local i = 0; i<maxPosition; i++){
				draw[i].text = text[(position-maxPosition+i)+1];
			}
		}
	}
	else{
		if(drawPosition==0){
			for(local i = 0; i<maxPosition; i++){
				draw[i].text = text[(position+i)-1];
			}
		}
		position--;
		if(drawPosition>0) drawPosition--;
	}
	draw[drawPosition].setColor(255, 255, 0);
}

function dialog::show(id, ...){
	switch(id){
		case 0: create(0, "M�czyzna", "Kobieta"); break;
		case 1: create(1, "Bia�a", "Czarna"); break;
		case 2: create(2, "Punkty trafie�", "Si�a", "Zr�czno��", "Bro� jednor�czna", "Bro� dwur�czna", "�ucznictwo",
		"Kusznictwo", "Opu��"); break;
		case 3: create(3, "Ryba 2 szt. z�.", "Chleb 3 szt. z�.", "Mi�d 5 szt. z�", "Ser 5 szt. z�.", "Opu��"); break;
		case 4: create(4, "Mikstura szybko�ci 3 szt. z�.", "Esencja lecznicza 15 szt. z�.", "Eliksir leczniczy 25 szt. z�", "Podw�jny M�ot 25 szt. z�" "Opu��"); break;
		case 5: create(5, "Str�j obywatela 100 szt. z�.", "Sk�rzany pancerz 220 szt. z�", "Pancerz Diega 600 szt. z�." "Opu��"); break;
		case 6: create(6, "Laga 12 szt. z�.", "Zardzewia�y top�r 110 szt. z�.", "N� na wilki 170 szt. z�.", "Opu��"); break;
		case 7: create(7, "25 strza� 25 szt. z�.", "25 be�t�w 25 szt. z�.", "Kr�tki �uk 70 szt. z�.", "Kusza my�liwska 90 szt. z�.", "Opu��"); break;
		case 8: create(8, "Zdeponuj przedmiot", "Odbierz przedmiot", "Opu��"); break;
		case 9:
			local eq = getEq(), i = 0, func = "create(9,";
			if(eq.len()>0){
				foreach(item in eq){
					if(i<30) func += format("\"%s - %d sztuk\",", item.instance.toupper(), item.amount);
					else break;
					++i;
				}
				func += "\"Opu��\");";
				local compiledScript = compilestring(func);
				compiledScript();
			}else{
				Chat.print(192, 192, 192, ">Nie posiadasz wi�cej item�w w ekwipunku.");
				dialog.destroy();
			}
		break;
		case 10:
			local deposit = split(vargv[0], "."), eq, func = "create(10,";
			for(local i = 0; i<deposit.len(); ++i){
				eq = split(deposit[i], ":");
				func += format("\"%s - %s sztuk\",", Items.name(eq[0].tointeger()), eq[1]);
			}
			func += "\"Opu��\");";
			local compiledScript = compilestring(func);
			compiledScript();
		break;

	}
}
