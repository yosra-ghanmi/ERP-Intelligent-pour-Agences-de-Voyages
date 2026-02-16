codeunit 50105 "Install Travel Data"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitTravelServices();
        InitClients();
        InitReservations();
        RegisterWebService();
    end;

    // --------------------------------------------------------------------------------
    // 1. Web Service Registration (Automatic API Publishing)
    // --------------------------------------------------------------------------------
    local procedure RegisterWebService()
    var
        PageId: Integer;
    begin
        // 1. Register Travel Service API
        PageId := Page::"Travel Service API";
        RegisterOneWebService(PageId, 'TravelServiceAPI');

        // 2. Register Travel Client API
        PageId := Page::"Travel Client API";
        RegisterOneWebService(PageId, 'TravelClientAPI');

        // 3. Register Travel Reservation API
        PageId := Page::"Travel Reservation API";
        RegisterOneWebService(PageId, 'TravelReservationAPI');
    end;

    local procedure RegisterOneWebService(PageId: Integer; ServiceName: Text[250])
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        TenantWebService.SetRange("Object Type", TenantWebService."Object Type"::Page);
        TenantWebService.SetRange("Object ID", PageId);

        if TenantWebService.IsEmpty() then begin
            TenantWebService.Init();
            TenantWebService."Object Type" := TenantWebService."Object Type"::Page;
            TenantWebService."Object ID" := PageId;
            TenantWebService."Service Name" := ServiceName;
            TenantWebService.Published := true;
            TenantWebService.Insert();
        end;
    end;

    // --------------------------------------------------------------------------------
    // 2. Travel Services (Tunisian Destinations)
    // --------------------------------------------------------------------------------
    local procedure InitTravelServices()
    var
        TravelService: Record "Travel Service";
    begin
        // --- Grand Tunis & North ---
        UpsertService('TS001', 'The Residence', TravelService."Service Type"::Hotel, 'Gammarth', 550.00, 36.9180, 10.2860, 'Luxury beachfront hotel in Gammarth featuring a golf course, spa, and refined dining.');
        UpsertService('TS002', 'Hôtel Dar Said', TravelService."Service Type"::Hotel, 'Sidi Bou Said', 450.00, 36.8712, 10.3461, 'Charming boutique hotel in Sidi Bou Said offering breathtaking views of the Gulf of Tunis.');
        UpsertService('TS003', 'Resto El Ali', TravelService."Service Type"::Activity, 'Tunis (Medina)', 65.00, 36.7990, 10.1710, 'Cultural space and restaurant in the Medina serving traditional Tunisian dishes on a rooftop terrace.');
        UpsertService('TS004', 'Hôtel Nour', TravelService."Service Type"::Hotel, 'Bizerte', 220.00, 37.2746, 9.8739, 'Comfortable seaside hotel in Bizerte, located near the old port and city center.');
        UpsertService('TS005', 'Site Archéologique Dougga', TravelService."Service Type"::Activity, 'Téboursouk', 15.00, 36.4225, 9.2203, 'UNESCO World Heritage site featuring the best-preserved Roman ruins in North Africa.');
        UpsertService('TS015', 'Musée National du Bardo', TravelService."Service Type"::Activity, 'Tunis', 13.00, 36.8093, 10.1345, 'World-renowned museum housing one of the largest collections of Roman mosaics.');
        UpsertService('TS016', 'Dar El Jeld', TravelService."Service Type"::Hotel, 'Tunis (Medina)', 350.00, 36.7988, 10.1701, 'Luxurious hotel and restaurant set in a restored traditional palace in the heart of the Medina.');
        UpsertService('TS018', 'Site Archéologique Carthage', TravelService."Service Type"::Activity, 'Carthage', 12.00, 36.8525, 10.3233, 'Ancient ruins of the Punic and Roman city of Carthage, a site of immense historical significance.');
        UpsertService('TS024', 'Hôtel Les Berges du Lac', TravelService."Service Type"::Hotel, 'Tunis Lac', 390.00, 36.8370, 10.2350, 'Modern business hotel located in the upscale Berges du Lac district with lake views.');
        UpsertService('TS025', 'Restaurant Au Bon Vieux Temps', TravelService."Service Type"::Activity, 'Sidi Bou Said', 80.00, 36.8715, 10.3455, 'Iconic restaurant offering French and Tunisian cuisine with a panoramic view of the sea.');

        // --- Sahel & Cap Bon ---
        UpsertService('TS006', 'Mövenpick Resort', TravelService."Service Type"::Hotel, 'Sousse', 400.00, 35.8390, 10.6340, '5-star resort in Sousse city center with a private beach and extensive pool facilities.');
        UpsertService('TS007', 'Amphithéâtre El Jem', TravelService."Service Type"::Activity, 'El Jem', 20.00, 34.9290, 10.7104, ' majestic Roman amphitheater, capable of seating 35,000 spectators, famously well-preserved.');
        UpsertService('TS008', 'Restaurant Le Pirate', TravelService."Service Type"::Activity, 'Monastir', 90.00, 35.7758, 10.8362, 'Famous seafood restaurant located by the marina in Monastir.');
        UpsertService('TS009', 'Hôtel La Kasbah', TravelService."Service Type"::Hotel, 'Kairouan', 190.00, 35.6760, 10.0960, 'Hotel built within the walls of the Kairouan medina, blending Islamic architecture with modern comfort.');
        UpsertService('TS017', 'Hôtel El Mouradi', TravelService."Service Type"::Hotel, 'Hammamet', 180.00, 36.3680, 10.5360, 'Large beachfront resort in Yasmine Hammamet offering entertainment and leisure activities.');
        UpsertService('TS019', 'Hôtel Delfino Beach', TravelService."Service Type"::Hotel, 'Nabeul', 150.00, 36.4380, 10.6690, 'Family-friendly club hotel situated on the sandy beaches of Nabeul.');
        UpsertService('TS027', 'Hôtel Continental', TravelService."Service Type"::Hotel, 'Kairouan', 110.00, 35.6720, 10.1020, 'Classic hotel in Kairouan offering a convenient base for exploring the holy city.');
        UpsertService('TS030', 'Port El Kantaoui', TravelService."Service Type"::Activity, 'Sousse', 0.00, 35.8950, 10.5980, 'Purpose-built tourist center and marina north of Sousse, known for its white buildings and cobblestone streets.');
        UpsertService('TS031', 'Ribat of Monastir', TravelService."Service Type"::Activity, 'Monastir', 10.00, 35.7760, 10.8330, 'Oldest ribat built by Arab conquerors in the Maghreb, offering panoramic views of the city and sea.');

        // --- North West ---
        UpsertService('TS021', 'Restaurant La Mer', TravelService."Service Type"::Activity, 'Tabarka', 55.00, 36.9580, 8.7560, 'Charming seafood restaurant in Tabarka overlooking the Mediterranean.');
        UpsertService('TS026', 'Hôtel Dar Ismail', TravelService."Service Type"::Hotel, 'Tabarka', 200.00, 36.9540, 8.7580, 'Upscale hotel in Tabarka offering spa facilities and easy access to the beach and mountains.');
        UpsertService('TS032', 'Bulla Regia Ruins', TravelService."Service Type"::Activity, 'Jendouba', 12.00, 36.5560, 8.7530, 'Famous for its Hadrianic-era semi-subterranean housing, a unique feature of Roman architecture.');
        UpsertService('TS033', 'Ain Draham Forest', TravelService."Service Type"::Activity, 'Ain Draham', 0.00, 36.7780, 8.6870, 'Dense cork oak forest offering hiking trails, fresh air, and a cool climate, especially in summer.');
        UpsertService('TS034', 'Tabarka Fort (Genoese)', TravelService."Service Type"::Activity, 'Tabarka', 5.00, 36.9630, 8.7500, 'Historical Genoese fortress located on an island connected to the mainland, offering panoramic views.');

        // --- South & Desert ---
        UpsertService('TS010', 'Camp Mars', TravelService."Service Type"::Hotel, 'Douz (Sahara)', 250.00, 33.4560, 9.0230, 'Unique desert camp experience in Timbaine, offering glamping tents amidst the sand dunes.');
        UpsertService('TS011', 'Musée Guellala', TravelService."Service Type"::Activity, 'Djerba', 10.00, 33.7260, 10.8560, 'Heritage museum in Djerba showcasing traditional Tunisian life, weddings, and crafts.');
        UpsertService('TS012', 'Djerba Explore Park', TravelService."Service Type"::Activity, 'Djerba', 25.00, 33.8190, 11.0450, 'Park featuring a crocodile farm, a heritage village, and the Lalla Hadria Museum.');
        UpsertService('TS013', 'Hôtel Radisson Blu', TravelService."Service Type"::Hotel, 'Djerba', 380.00, 33.8430, 11.0110, 'Luxury beachfront resort on Djerba Island known for its thalassotherapy center.');
        UpsertService('TS014', 'Mosquée Okba Ibn Nafaa', TravelService."Service Type"::Activity, 'Kairouan', 8.00, 35.6800, 10.1000, 'The Great Mosque of Kairouan, one of the most important Islamic monuments in North Africa.');
        UpsertService('TS020', 'Hôtel El Mansour', TravelService."Service Type"::Hotel, 'Mahdia', 210.00, 35.5020, 11.0620, 'Beachfront hotel in Mahdia, known for its beautiful sandy beaches and clear waters.');
        UpsertService('TS022', 'Dar Dhiafa', TravelService."Service Type"::Hotel, 'Djerba (Erriadh)', 180.00, 33.8680, 10.8560, 'Traditional boutique hotel in Djerba composed of restored houchs (traditional houses).');
        UpsertService('TS023', 'Chenini Village', TravelService."Service Type"::Activity, 'Tataouine', 0.00, 32.9120, 10.2630, 'Ancient Berber hilltop village in Tataouine, famous for its ksour (fortified granaries).');
        UpsertService('TS028', 'Matmata Troglodyte', TravelService."Service Type"::Activity, 'Matmata', 15.00, 33.5420, 9.9670, 'Underground troglodyte homes famous for being the filming location of Star Wars (Luke Skywalkers home).');
        UpsertService('TS029', 'Chott El Jerid', TravelService."Service Type"::Activity, 'Tozeur', 0.00, 33.7000, 8.4160, 'Massive salt lake in southern Tunisia, offering surreal landscapes and mirages.');
        UpsertService('TS035', 'Ksar Ouled Soltane', TravelService."Service Type"::Activity, 'Tataouine', 5.00, 32.7880, 10.5130, 'Well-preserved fortified granary (ksar) featured in Star Wars, showcasing traditional Berber architecture.');
        UpsertService('TS040', 'Ong Jmal', TravelService."Service Type"::Activity, 'Tozeur', 0.00, 33.9980, 8.4120, 'Famous Star Wars filming location (Mos Espa) in the desert near Tozeur.');
        UpsertService('TS050', 'Mahdia Beach Hotel', TravelService."Service Type"::Hotel, 'Mahdia', 195.00, 35.5100, 11.0500, 'Family resort on one of the best beaches in Tunisia.');
    end;

    local procedure UpsertService(Code: Code[20]; Name: Text[100]; ServiceType: Option; Location: Text[100]; Price: Decimal; Lat: Decimal; Lon: Decimal; Desc: Text[250])
    var
        TravelService: Record "Travel Service";
    begin
        if TravelService.Get(Code) then begin
            TravelService.Name := Name;
            TravelService."Service Type" := ServiceType;
            TravelService.Location := Location;
            TravelService.Price := Price;
            TravelService.Latitude := Lat;
            TravelService.Longitude := Lon;
            TravelService.Description := Desc;
            TravelService."Currency Code" := 'TND'; // Ensure TND is set
            TravelService.Modify();
        end else begin
            TravelService.Init();
            TravelService.Code := Code;
            TravelService.Name := Name;
            TravelService."Service Type" := ServiceType;
            TravelService.Location := Location;
            TravelService.Price := Price;
            TravelService.Latitude := Lat;
            TravelService.Longitude := Lon;
            TravelService.Description := Desc;
            TravelService."Currency Code" := 'TND';
            TravelService.Insert();
        end;
    end;

    // --------------------------------------------------------------------------------
    // 3. Travel Clients
    // --------------------------------------------------------------------------------
    local procedure InitClients()
    begin
        UpsertClient('CL001', 'Ahmed Ben Salem', 'History & Roman Ruins');
        UpsertClient('CL002', 'Sarah Mansour', 'Luxury & Spa');
        UpsertClient('CL003', 'Youssef Gharbi', 'Adventure & Desert');
        UpsertClient('CL004', 'Mohamed Ali', 'Culture & Food');
        UpsertClient('CL005', 'Amira Toumi', 'Beaches & Relaxation');
        UpsertClient('CL006', 'Sami Karray', 'Golf & Leisure');
        UpsertClient('CL007', 'Leila Ben Amor', 'Nature & Hiking');
        UpsertClient('CL008', 'Hamza Dridi', 'History & Museums');
        UpsertClient('CL009', 'Nour El Houda', 'Photography & Landscapes');
        UpsertClient('CL010', 'Oussama Jbali', 'Architecture & Tradition');
        UpsertClient('CL011', 'Faten Trabelsi', 'Wellness & Yoga');

        // Extended Clients (CL012-CL021)
        UpsertClient('CL012', 'Karim Jaziri', 'Scuba Diving & Water Sports');
        UpsertClient('CL013', 'Hela Bouazizi', 'Budget Travel & Backpacking');
        UpsertClient('CL014', 'Riad Mejbri', 'Religious Heritage');
        UpsertClient('CL015', 'Salma Hichri', 'Family Friendly Activities');
        UpsertClient('CL016', 'Omar Zghal', 'Nightlife & Entertainment');
        UpsertClient('CL017', 'Meriem Fekih', 'Art & Crafts');
        UpsertClient('CL018', 'Walid Tounsi', 'Gastronomy & Cooking Classes');
        UpsertClient('CL019', 'Imen Sassi', 'Eco-Tourism & Sustainability');
        UpsertClient('CL020', 'Anis Louhichi', 'Road Trips & Driving');
        UpsertClient('CL021', 'Sonia Mbarek', 'Music & Festivals');
    end;

    local procedure UpsertClient(ClientNo: Code[20]; Name: Text[100]; Prefs: Text[250])
    var
        TravelClient: Record "Travel Client";
    begin
        if TravelClient.Get(ClientNo) then begin
            TravelClient.Name := Name;
            TravelClient."AI_Preferences" := Prefs;
            TravelClient.Modify();
        end else begin
            TravelClient.Init();
            TravelClient."No." := ClientNo;
            TravelClient.Name := Name;
            TravelClient."AI_Preferences" := Prefs;
            TravelClient.Insert();
        end;
    end;

    // --------------------------------------------------------------------------------
    // 4. Travel Reservations
    // --------------------------------------------------------------------------------
    local procedure InitReservations()
    begin
        UpsertReservation('RES001', 'CL001', 'TS005', 20260115D); // Ahmed -> Dougga
        UpsertReservation('RES002', 'CL002', 'TS001', 20260120D); // Sarah -> Residence
        UpsertReservation('RES003', 'CL003', 'TS010', 20260201D); // Youssef -> Camp Mars

        // Extended Reservations
        UpsertReservation('RES004', 'CL004', 'TS015', 20260214D); // Mohamed -> Bardo
        UpsertReservation('RES005', 'CL005', 'TS020', 20260214D); // Amira -> El Mansour
        UpsertReservation('RES006', 'CL006', 'TS001', 20260215D); // Sami -> Residence (Corrected code)
        UpsertReservation('RES007', 'CL007', 'TS028', 20260215D); // Leila -> Matmata
        UpsertReservation('RES008', 'CL008', 'TS012', 20260216D); // Hamza -> Djerba Explore
        UpsertReservation('RES009', 'CL009', 'TS040', 20260216D); // Nour -> Ong Jmal
        UpsertReservation('RES010', 'CL010', 'TS016', 20260217D); // Oussama -> Dar El Jeld
        UpsertReservation('RES011', 'CL001', 'TS026', 20260218D); // Ahmed -> Dar Ismail
        UpsertReservation('RES012', 'CL002', 'TS035', 20260218D); // Sarah -> Ksar Ouled Soltane
        UpsertReservation('RES013', 'CL011', 'TS050', 20260219D); // Faten -> Mahdia Beach
    end;

    local procedure UpsertReservation(ResNo: Code[20]; ClientNo: Code[20]; ServiceCode: Code[20]; ResDate: Date)
    var
        TravelReservation: Record "Travel Reservation";
    begin
        if TravelReservation.Get(ResNo) then begin
            TravelReservation."Client No." := ClientNo;
            TravelReservation."Service Code" := ServiceCode;
            TravelReservation."Reservation Date" := ResDate;
            TravelReservation.Status := TravelReservation.Status::Confirmed;
            TravelReservation.Modify();
        end else begin
            TravelReservation.Init();
            TravelReservation."Reservation No." := ResNo;
            TravelReservation."Client No." := ClientNo;
            TravelReservation."Service Code" := ServiceCode;
            TravelReservation."Reservation Date" := ResDate;
            TravelReservation.Status := TravelReservation.Status::Confirmed;
            TravelReservation.Insert();
        end;
    end;
}
