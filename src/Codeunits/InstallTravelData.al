codeunit 50616 "Install Travel Data"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);

        // Only run initialization if this is a fresh install or if we explicitly want to update data
        if AppInfo.DataVersion() = Version.Create(0, 0, 0, 0) then begin
            InitTravelServices();
            InitClients();
            InitReservations();
            RegisterWebService();
        end else begin
            // Optional: You can still run Upsert logic here if you want to update existing records
            // on every extension upgrade, but wrapping it in this condition prevents
            // unnecessary work if you only want it on first install.
            // For safety, we'll run it to ensure data is up-to-date, as Upsert handles existing records.
            InitTravelServices();
            InitClients();
            InitReservations();
            RegisterWebService();
        end;
    end;

    local procedure RegisterWebService()
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        // Register TravelClientAPI (Page 50610 - Travel Client List)
        RegisterSingleWebService(Page::"Travel Client List", 'TravelClientAPI');

        // Register TravelServiceAPI (Page 50612 - Travel Service List)
        RegisterSingleWebService(Page::"Travel Service List", 'TravelServiceAPI');

        // Register TravelReservationAPI (Page 50613 - Travel Reservation List)
        RegisterSingleWebService(Page::"Travel Reservation List", 'TravelReservationAPI');
    end;

    local procedure RegisterSingleWebService(PageId: Integer; ServiceName: Text[240])
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
            if not TenantWebService.Insert() then
                ; // Ignore error
        end else begin
            // If it exists but with a different name, update it
            if TenantWebService.FindFirst() then;
            if TenantWebService."Service Name" <> ServiceName then begin
                TenantWebService."Service Name" := ServiceName;
                TenantWebService.Published := true;
                if not TenantWebService.Modify() then
                    ; // Ignore error
            end;
        end;
    end;

    local procedure InitTravelServices()
    var
        TravelService: Record "Travel Service";
    begin
        // --- Grand Tunis & North ---
        // 1. The Residence (Gammarth)
        UpsertService('TS001', 'The Residence', TravelService."Service Type"::Hotel, 'Gammarth', 550.00, 36.9180, 10.2860, 'Luxury beachfront hotel in Gammarth featuring a golf course, spa, and refined dining.');

        // 2. Dar Said (Sidi Bou Said)
        UpsertService('TS002', 'Hôtel Dar Said', TravelService."Service Type"::Hotel, 'Sidi Bou Said', 450.00, 36.8712, 10.3461, 'Charming boutique hotel in Sidi Bou Said offering breathtaking views of the Gulf of Tunis.');

        // 3. Resto El Ali (Tunis Medina)
        UpsertService('TS003', 'Resto El Ali', TravelService."Service Type"::Activity, 'Tunis (Medina)', 65.00, 36.7990, 10.1710, 'Cultural space and restaurant in the Medina serving traditional Tunisian dishes on a rooftop terrace.');

        // 4. Hôtel Nour (Bizerte)
        UpsertService('TS004', 'Hôtel Nour', TravelService."Service Type"::Hotel, 'Bizerte', 220.00, 37.2746, 9.8739, 'Comfortable seaside hotel in Bizerte, located near the old port and city center.');

        // 5. Site Archéologique Dougga (Téboursouk)
        UpsertService('TS005', 'Site Archéologique Dougga', TravelService."Service Type"::Activity, 'Téboursouk', 15.00, 36.4225, 9.2203, 'UNESCO World Heritage site featuring the best-preserved Roman ruins in North Africa.');

        // 6. Musée National du Bardo (Tunis) - Restored
        UpsertService('TS015', 'Musée National du Bardo', TravelService."Service Type"::Activity, 'Tunis', 13.00, 36.8093, 10.1345, 'World-renowned museum housing one of the largest collections of Roman mosaics.');

        // 7. Dar El Jeld (Tunis Medina)
        UpsertService('TS016', 'Dar El Jeld', TravelService."Service Type"::Hotel, 'Tunis (Medina)', 350.00, 36.7988, 10.1701, 'Luxurious hotel and restaurant set in a restored traditional palace in the heart of the Medina.');

        // 8. Site Archéologique Carthage (Carthage)
        UpsertService('TS018', 'Site Archéologique Carthage', TravelService."Service Type"::Activity, 'Carthage', 12.00, 36.8525, 10.3233, 'Ancient ruins of the Punic and Roman city of Carthage, a site of immense historical significance.');

        // 9. Hôtel Les Berges du Lac (Tunis Lac)
        UpsertService('TS024', 'Hôtel Les Berges du Lac', TravelService."Service Type"::Hotel, 'Tunis Lac', 390.00, 36.8370, 10.2350, 'Modern business hotel located in the upscale Berges du Lac district with lake views.');

        // 10. Restaurant Au Bon Vieux Temps (Sidi Bou Said)
        UpsertService('TS025', 'Restaurant Au Bon Vieux Temps', TravelService."Service Type"::Activity, 'Sidi Bou Said', 80.00, 36.8715, 10.3455, 'Iconic restaurant offering French and Tunisian cuisine with a panoramic view of the sea.');


        // --- Sahel & Cap Bon ---
        // 11. Mövenpick (Sousse)
        UpsertService('TS006', 'Mövenpick Resort', TravelService."Service Type"::Hotel, 'Sousse', 400.00, 35.8390, 10.6340, '5-star resort in Sousse city center with a private beach and extensive pool facilities.');

        // 12. Amphithéâtre El Jem (El Jem)
        UpsertService('TS007', 'Amphithéâtre El Jem', TravelService."Service Type"::Activity, 'El Jem', 20.00, 34.9290, 10.7104, ' majestic Roman amphitheater, capable of seating 35,000 spectators, famously well-preserved.');

        // 13. Resto Le Pirate (Monastir)
        UpsertService('TS008', 'Restaurant Le Pirate', TravelService."Service Type"::Activity, 'Monastir', 90.00, 35.7758, 10.8362, 'Famous seafood restaurant located by the marina in Monastir.');

        // 14. Hôtel La Kasbah (Kairouan)
        UpsertService('TS009', 'Hôtel La Kasbah', TravelService."Service Type"::Hotel, 'Kairouan', 190.00, 35.6760, 10.0960, 'Hotel built within the walls of the Kairouan medina, blending Islamic architecture with modern comfort.');

        // 15. Hôtel El Mouradi (Hammamet)
        UpsertService('TS017', 'Hôtel El Mouradi', TravelService."Service Type"::Hotel, 'Hammamet', 180.00, 36.3680, 10.5360, 'Large beachfront resort in Yasmine Hammamet offering entertainment and leisure activities.');

        // 16. Hôtel Delfino Beach (Nabeul)
        UpsertService('TS019', 'Hôtel Delfino Beach', TravelService."Service Type"::Hotel, 'Nabeul', 150.00, 36.4380, 10.6690, 'Family-friendly club hotel situated on the sandy beaches of Nabeul.');

        // 17. Hôtel Continental (Kairouan) - New
        UpsertService('TS027', 'Hôtel Continental', TravelService."Service Type"::Hotel, 'Kairouan', 110.00, 35.6720, 10.1020, 'Classic hotel in Kairouan offering a convenient base for exploring the holy city.');

        // 18. Port El Kantaoui (Sousse) - New Extra
        UpsertService('TS030', 'Port El Kantaoui', TravelService."Service Type"::Activity, 'Sousse', 0.00, 35.8950, 10.5980, 'Purpose-built tourist center and marina north of Sousse, known for its white buildings and cobblestone streets.');

        // 19. Ribat of Monastir (Monastir) - New Extra
        UpsertService('TS031', 'Ribat of Monastir', TravelService."Service Type"::Activity, 'Monastir', 10.00, 35.7760, 10.8330, 'Oldest ribat built by Arab conquerors in the Maghreb, offering panoramic views of the city and sea.');


        // --- North West ---
        // 20. Restaurant La Mer (Tabarka)
        UpsertService('TS021', 'Restaurant La Mer', TravelService."Service Type"::Activity, 'Tabarka', 55.00, 36.9580, 8.7560, 'Charming seafood restaurant in Tabarka overlooking the Mediterranean.');

        // 21. Hôtel Itropika (Tabarka)
        UpsertService('TS022', 'Hôtel Itropika', TravelService."Service Type"::Hotel, 'Tabarka', 160.00, 36.9550, 8.7520, 'Beach hotel in Tabarka nestled between the forest and the sea.');


        // --- South & Islands ---
        // 22. Hasdrubal Prestige (Djerba)
        UpsertService('TS010', 'Hasdrubal Prestige', TravelService."Service Type"::Hotel, 'Djerba', 380.00, 33.8247, 11.0133, 'Luxurious thalassotherapy hotel in Djerba featuring oriental architecture and vast lagoons.');

        // 23. Camp Mars (Douz - Desert)
        UpsertService('TS011', 'Camp Mars', TravelService."Service Type"::Hotel, 'Douz (Sahara)', 180.00, 33.0022, 9.1554, 'Ecological tented camp in the heart of the Grand Erg Oriental, offering a pure desert experience.');

        // 24. Diar Abou Habibi (Tozeur)
        UpsertService('TS012', 'Diar Abou Habibi', TravelService."Service Type"::Hotel, 'Tozeur', 260.00, 33.9130, 8.1250, 'Unique eco-lodge in the Tozeur palm grove featuring wooden treehouses.');

        // 25. Hôtel Sangho (Tataouine)
        UpsertService('TS013', 'Hôtel Sangho Privilege', TravelService."Service Type"::Hotel, 'Tataouine', 140.00, 32.9297, 10.4518, 'Hotel in Tataouine offering bungalows blending into the rocky landscape.');

        // 26. Musée Guellala (Djerba)
        UpsertService('TS014', 'Musée de Guellala', TravelService."Service Type"::Activity, 'Djerba', 10.00, 33.7314, 10.8631, 'Ethnographic museum in Djerba showcasing traditional Berber life and pottery.');

        // 27. Dar Hi (Nefta)
        UpsertService('TS020', 'Dar Hi', TravelService."Service Type"::Hotel, 'Nefta', 290.00, 33.8732, 7.8845, 'Contemporary eco-retreat in Nefta designed by Matali Crasset, overlooking the Corbeille.');

        // 28. Chenini (Tataouine)
        UpsertService('TS023', 'Chenini', TravelService."Service Type"::Activity, 'Tataouine', 0.00, 32.9110, 10.2620, 'Ancient Berber fortified granary (ksar) perched on a hilltop, a key filming location for Star Wars.');

        // 29. Djerba Explore (Djerba) - New
        UpsertService('TS026', 'Djerba Explore Park', TravelService."Service Type"::Activity, 'Djerba', 25.00, 33.8200, 11.0450, 'Cultural and leisure park in Djerba featuring a crocodile farm, heritage museum, and traditional village.');

        // 30. Hotel Sidi Driss (Matmata) - New Extra
        UpsertService('TS028', 'Hotel Sidi Driss', TravelService."Service Type"::Hotel, 'Matmata', 80.00, 33.5420, 9.9670, 'Famous troglodyte hotel in Matmata, known worldwide as the filming location for Luke Skywalker''s home in Star Wars.');

        // 31. Great Mosque of Kairouan (Kairouan) - New Extra
        UpsertService('TS029', 'Great Mosque of Kairouan', TravelService."Service Type"::Activity, 'Kairouan', 12.00, 35.6800, 10.1030, 'One of the most important mosques in the Islamic world and a masterpiece of architectural and spiritual significance.');

        // 32. Douz Museum (Douz) - New Extra
        UpsertService('TS032', 'Douz Museum', TravelService."Service Type"::Activity, 'Douz (Sahara)', 10.00, 33.4560, 9.0250, 'Museum dedicated to showcasing the desert life, traditions, and culture of the nomadic tribes.');

        // 33. Chott el Djerid (Tozeur) - New Extra
        UpsertService('TS033', 'Chott el Djerid', TravelService."Service Type"::Activity, 'Tozeur', 0.00, 33.7000, 8.4167, 'Vast salt lake offering surreal landscapes and mirages, located between Tozeur and Kebili.');

        // 34. Medina of Sousse (Sousse) - New Extra
        UpsertService('TS034', 'Medina of Sousse', TravelService."Service Type"::Activity, 'Sousse', 0.00, 35.8256, 10.6411, 'Historic walled city featuring the Ribat and Great Mosque, recognized as a UNESCO World Heritage site.');

        // 35. Dar Ben Gacem (Tunis Medina) - New Extra
        UpsertService('TS035', 'Dar Ben Gacem', TravelService."Service Type"::Hotel, 'Tunis (Medina)', 280.00, 36.8000, 10.1680, 'Beautifully restored boutique hotel in a 17th-century house, offering an authentic Medina experience.');

        // --- Cap Bon & North-East ---
        // 36. Kelibia Fort (Kelibia)
        UpsertService('TS036', 'Kelibia Fort', TravelService."Service Type"::Activity, 'Kelibia', 10.00, 36.8500, 11.1000, 'Majestic 16th-century fortress overlooking the Mediterranean Sea.');

        // 37. Hôtel El Mansour (Kelibia)
        UpsertService('TS037', 'Hôtel El Mansour', TravelService."Service Type"::Hotel, 'Kelibia', 180.00, 36.8450, 11.0900, 'Seaside hotel in Kelibia offering direct access to one of the most beautiful beaches in Tunisia.');

        // 38. Pueblo (Haouaria)
        UpsertService('TS038', 'Pueblo', TravelService."Service Type"::Activity, 'Haouaria', 60.00, 37.0500, 11.0100, 'Popular restaurant in Haouaria known for its fresh seafood and relaxed atmosphere.');


        // --- North-West & Nature ---
        // 39. Les Aiguilles (Tabarka)
        UpsertService('TS039', 'Les Aiguilles', TravelService."Service Type"::Activity, 'Tabarka', 0.00, 36.9580, 8.7500, 'Iconic rock formations rising from the sea, a symbol of Tabarka''s coastline.');

        // 40. Dar Ismail (Tabarka)
        UpsertService('TS040', 'Dar Ismail', TravelService."Service Type"::Hotel, 'Tabarka', 210.00, 36.9520, 8.7600, 'Luxury hotel in Tabarka featuring a spa, pool, and views of the mountains and sea.');

        // 41. Bulla Regia (Jendouba)
        UpsertService('TS041', 'Bulla Regia', TravelService."Service Type"::Activity, 'Jendouba', 12.00, 36.5500, 8.7500, 'Ancient Roman city famous for its unique underground villas with preserved mosaics.');


        // --- Center & Sahel ---
        // 42. Sousse Medina (Sousse) - Distinct from TS034
        UpsertService('TS042', 'Sousse Medina', TravelService."Service Type"::Activity, 'Sousse', 0.00, 35.8270, 10.6380, 'Vibrant historic center of Sousse, filled with souks, traditional crafts, and monuments.');

        // 43. Hôtel Tej Marhaba (Sousse)
        UpsertService('TS043', 'Hôtel Tej Marhaba', TravelService."Service Type"::Hotel, 'Sousse', 140.00, 35.8350, 10.6300, 'Comfortable hotel in Sousse located near the beach and the city''s main attractions.');

        // 44. Marina Cap Monastir (Monastir)
        UpsertService('TS044', 'Marina Cap Monastir', TravelService."Service Type"::Activity, 'Monastir', 25.00, 35.7760, 10.8300, 'Modern marina complex in Monastir with shops, cafes, and boat trips.');


        // --- Deep South & Berber Villages ---
        // 45. Matmata Troglodyte (Matmata)
        UpsertService('TS045', 'Matmata Troglodyte', TravelService."Service Type"::Activity, 'Matmata', 15.00, 33.5450, 9.9670, 'Traditional underground dwellings carved into the rock, offering a glimpse into Berber life.');

        // 46. Hôtel Diar El Barbar (Matmata)
        UpsertService('TS046', 'Hôtel Diar El Barbar', TravelService."Service Type"::Hotel, 'Matmata', 160.00, 33.5420, 9.9700, 'Hotel in Matmata designed to resemble traditional troglodyte architecture.');

        // 47. Ksar Ouled Soltane (Tataouine)
        UpsertService('TS047', 'Ksar Ouled Soltane', TravelService."Service Type"::Activity, 'Tataouine', 5.00, 32.7880, 10.5150, 'Well-preserved fortified granary (ksar) with multi-story ghorfas, a Star Wars filming location.');

        // 48. Ong Jmal (Nefta)
        UpsertService('TS048', 'Ong Jmal', TravelService."Service Type"::Activity, 'Nefta', 30.00, 33.9900, 7.8400, 'Famous "Camel Neck" rock formation and Star Wars Mos Espa set in the desert.');

        // 49. Temple des Eaux (Zaghouan) - New Extra
        UpsertService('TS049', 'Temple des Eaux', TravelService."Service Type"::Activity, 'Zaghouan', 5.00, 36.3930, 10.1430, 'Roman water temple marking the source of the aqueduct that supplied Carthage.');

        // 50. Ichkeul National Park (Bizerte) - New Extra
        UpsertService('TS050', 'Ichkeul National Park', TravelService."Service Type"::Activity, 'Bizerte', 0.00, 37.1600, 9.6700, 'UNESCO World Heritage site known for its lake, wetlands, and migratory birds.');

        // 51. Mahdia Beach (Mahdia) - New Extra
        UpsertService('TS051', 'Mahdia Beach Hotel', TravelService."Service Type"::Hotel, 'Mahdia', 140.00, 35.5000, 11.0400, 'Relaxing beachfront hotel in Mahdia with golden sands and turquoise waters.');
    end;

    local procedure InitClients()
    var
        Client: Record "Travel Client";
    begin
        // Ahmed
        UpsertClient('CL001', 'Ahmed Ben Salem', 'Luxe, histoire andalouse, vue mer');

        // Sarah
        UpsertClient('CL002', 'Sarah Mansour', 'Aventure, Sahara, camping, petit budget');

        // Yassine
        UpsertClient('CL003', 'Yassine Jlassi', 'Famille, plage, tout inclus, détente');

        // CL004 (Mohamed Ali)
        UpsertClient('CL004', 'Mohamed Ali', 'History, Culture, Fortresses');

        // CL005 (Amira Toumi)
        UpsertClient('CL005', 'Amira Toumi', 'Luxury, Beach, Relaxation');

        // CL006 (Sami Karray)
        UpsertClient('CL006', 'Sami Karray', 'Luxury, Golf, Spa');

        // CL007 (Leila Ben Amor)
        UpsertClient('CL007', 'Leila Ben Amor', 'Nature, Unique Experiences, Berber Culture');

        // CL008 (Hamza Dridi)
        UpsertClient('CL008', 'Hamza Dridi', 'Activities, Parks, Wildlife');

        // CL009 (Nour El Houda)
        UpsertClient('CL009', 'Nour El Houda', 'Movies, Desert, Adventure');

        // CL010 (Oussama Jbali)
        UpsertClient('CL010', 'Oussama Jbali', 'Dining, Culture, Medina');

        // CL011 (Faten Trabelsi)
        UpsertClient('CL011', 'Faten Trabelsi', 'Beach, Family, Swimming');

        // CL012 (Youssef Bouaziz)
        UpsertClient('CL012', 'Youssef Bouaziz', 'History & Roman Ruins, Archeology');

        // CL013 (Rania Mezhoud)
        UpsertClient('CL013', 'Rania Mezhoud', 'Scuba Diving & Water Sports, Adventure');

        // CL014 (Karim Gharbi)
        UpsertClient('CL014', 'Karim Gharbi', 'Budget Travel & Hiking, Nature');

        // CL015 (Lobna Abid)
        UpsertClient('CL015', 'Lobna Abid', 'Photography & Landscapes, Scenic Views');

        // CL016 (Mehdi Chaouachi)
        UpsertClient('CL016', 'Mehdi Chaouachi', 'Wellness & Spa, Relaxation, Luxury');

        // CL017 (Mariem Ferjani)
        UpsertClient('CL017', 'Mariem Ferjani', 'Religious Heritage, Culture, Mosques');

        // CL018 (Walid Tounsi)
        UpsertClient('CL018', 'Walid Tounsi', 'Luxury & Gastronomy, Fine Dining');

        // CL019 (Ines Hamdi)
        UpsertClient('CL019', 'Ines Hamdi', 'Desert & Adventure, 4x4, Sahara');

        // CL020 (Sofiene Ben Ammar)
        UpsertClient('CL020', 'Sofiene Ben Ammar', 'Family & Leisure, Theme Parks');

        // CL021 (Hela Rekik)
        UpsertClient('CL021', 'Hela Rekik', 'Architecture & Museums, Art, History');
    end;

    local procedure InitReservations()
    var
        Reservation: Record "Travel Reservation";
    begin
        // Ahmed -> Dar Said (TS002)
        UpsertReservation('RES001', 'CL001', 'TS002', Today());

        // Sarah -> Camp Mars (TS011)
        UpsertReservation('RES002', 'CL002', 'TS011', Today());

        // Yassine -> Mövenpick (TS006)
        UpsertReservation('RES003', 'CL003', 'TS006', Today());

        // RES004: Client: CL004 (Mohamed Ali) | Service: TS036 (Kelibia Fort) | Date: 14/02/2026
        UpsertReservation('RES004', 'CL004', 'TS036', DMY2Date(14, 2, 2026));

        // RES005: Client: CL005 (Amira Toumi) | Service: TS037 (Hôtel El Mansour) | Date: 14/02/2026
        UpsertReservation('RES005', 'CL005', 'TS037', DMY2Date(14, 2, 2026));

        // RES006: Client: CL006 (Sami Karray) | Service: TS001 (The Residence) | Date: 15/02/2026
        UpsertReservation('RES006', 'CL006', 'TS001', DMY2Date(15, 2, 2026));

        // RES007: Client: CL007 (Leila Ben Amor) | Service: TS045 (Matmata Troglodyte) | Date: 15/02/2026
        UpsertReservation('RES007', 'CL007', 'TS045', DMY2Date(15, 2, 2026));

        // RES008: Client: CL008 (Hamza Dridi) | Service: TS026 (Djerba Explore) | Date: 16/02/2026
        UpsertReservation('RES008', 'CL008', 'TS026', DMY2Date(16, 2, 2026));

        // RES009: Client: CL009 (Nour El Houda) | Service: TS048 (Ong Jmal) | Date: 16/02/2026
        UpsertReservation('RES009', 'CL009', 'TS048', DMY2Date(16, 2, 2026));

        // RES010: Client: CL010 (Oussama Jbali) | Service: TS016 (Dar El Jeld) | Date: 17/02/2026
        UpsertReservation('RES010', 'CL010', 'TS016', DMY2Date(17, 2, 2026));

        // RES011: Client: CL001 (Ahmed Ben Salem) | Service: TS040 (Dar Ismail) | Date: 18/02/2026
        UpsertReservation('RES011', 'CL001', 'TS040', DMY2Date(18, 2, 2026));

        // RES012: Client: CL002 (Sarah Mansour) | Service: TS047 (Ksar Ouled Soltane) | Date: 18/02/2026
        UpsertReservation('RES012', 'CL002', 'TS047', DMY2Date(18, 2, 2026));

        // RES013: Client: CL011 (Faten Trabelsi) | Service: TS051 (Mahdia Beach) | Date: 19/02/2026
        UpsertReservation('RES013', 'CL011', 'TS051', DMY2Date(19, 2, 2026));
    end;

    local procedure UpsertService(Code: Code[20]; Name: Text[100]; Type: Option; Location: Text[50]; Price: Decimal; Lat: Decimal; Lon: Decimal; Description: Text[2048])
    var
        TravelService: Record "Travel Service";
    begin
        if TravelService.Get(Code) then begin
            TravelService.Name := Name;
            TravelService."Service Type" := Type;
            TravelService.Location := Location;
            TravelService.Price := Price;
            TravelService.Latitude := Lat;
            TravelService.Longitude := Lon;
            TravelService.Description := Description; // Using Description field for the AI text
            TravelService."Long Description" := Description; // Also filling Long Description
            TravelService."Currency Code" := 'TND'; // Ensure Currency Code is always TND
            if not TravelService.Modify() then
                ; // Ignore error
        end else begin
            TravelService.Init();
            TravelService.Code := Code;
            TravelService.Name := Name;
            TravelService."Service Type" := Type;
            TravelService.Location := Location;
            TravelService.Price := Price;
            TravelService.Latitude := Lat;
            TravelService.Longitude := Lon;
            TravelService.Description := Description;
            TravelService."Long Description" := Description;
            TravelService."Currency Code" := 'TND'; // Ensure Currency Code is always TND
            if not TravelService.Insert() then
                ; // Ignore error if it somehow exists
        end;
    end;

    local procedure UpsertClient(No: Code[20]; Name: Text[100]; Preferences: Text[250])
    var
        Client: Record "Travel Client";
    begin
        if Client.Get(No) then begin
            Client.Name := Name;
            Client."AI_Preferences" := Preferences;
            if not Client.Modify() then
                ; // Ignore error
        end else begin
            Client.Init();
            Client."No." := No;
            Client.Name := Name;
            Client."AI_Preferences" := Preferences;
            if not Client.Insert() then
                ; // Ignore error if it somehow exists
        end;
    end;

    local procedure UpsertReservation(ResNo: Code[20]; ClientNo: Code[20]; ServiceCode: Code[20]; ResDate: Date)
    var
        Reservation: Record "Travel Reservation";
    begin
        if not Reservation.Get(ResNo) then begin
            Reservation.Init();
            Reservation."Reservation No." := ResNo;
            Reservation."Client No." := ClientNo;
            Reservation."Service Code" := ServiceCode;
            Reservation."Reservation Date" := ResDate;
            Reservation.Status := Reservation.Status::Confirmed;
            if not Reservation.Insert() then
                ; // Ignore error if it somehow exists
        end;
        // Note: We don't modify existing reservations to preserve history
    end;
}
