@testset "MC: IsingModel Simulation" begin
    Random.seed!(123)
    m = IsingModel(dims=2, L=8);
    mc = MC(m, beta=0.35);
    run!(mc, sweeps=1000, thermalization=10, verbose=false);

    # Check measurements
    measured = measurements(mc)
    @test   25.47  ≈ measured[:Magn].M |> mean         atol=0.01
    @test    0.82  ≈ measured[:Magn].M |> std_error    atol=0.01
    @test  887.    ≈ measured[:Magn].M2 |> mean        atol=1.0
    @test   46.    ≈ measured[:Magn].M2 |> std_error   atol=1.0
    @test    0.398 ≈ measured[:Magn].m |> mean         atol=0.001
    @test    0.013 ≈ measured[:Magn].m |> std_error    atol=0.001
    @test    1.300 ≈ measured[:Magn].chi |> mean       atol=0.001

    @test  -59.10  ≈ measured[:Energy].E |> mean       atol=0.01
    @test    0.88  ≈ measured[:Energy].E |> std_error  atol=0.01
    @test 3799.    ≈ measured[:Energy].E2 |> mean      atol=1.0
    @test  111.    ≈ measured[:Energy].E2 |> std_error atol=1.0
    @test   -0.924 ≈ measured[:Energy].e |> mean       atol=0.001
    @test    0.014 ≈ measured[:Energy].e |> std_error  atol=0.001
    @test    0.585 ≈ measured[:Energy].C |> mean       atol=0.001

    @test isempty(mc.configs) == true
end


@testset "DQMC: HubbardModel Simulation" begin
    Random.seed!(123)
    m = HubbardModelAttractive(dims=2, L=4);
    N = 4*4
    mc = DQMC(m, beta=1.0);
    mask = DistanceMask(lattice(m))
    MonteCarlo.unsafe_push!(mc, :CDC => ChargeDensityCorrelationMeasurement(mc, m, mask=mask))
    MonteCarlo.unsafe_push!(mc, :SDC => SpinDensityCorrelationMeasurement(mc, m, mask=mask))
    MonteCarlo.unsafe_push!(mc, :PC => PairingCorrelationMeasurement(mc, m, mask=mask))
    run!(mc, sweeps=1000, thermalization=10, verbose=false);

    # Check measurements
    measured = measurements(mc)

    # Greens
    @test [
        0.49561029949409063 -0.14109173845075434 0.0038059320775097904 -0.15105139063556972 -0.14545014986908916 8.803222558817584e-5 0.032636836096280486 0.0011020560884685193 0.001981442814477704 0.03498167403603113 -0.0006287109079948074 0.03453088342227544 -0.14658908837491919 -0.00013396457500533423 0.029229326644345757 8.263499723168061e-5; -0.16876650087331765 0.5456869842396492 -0.16090801844840794 -0.003418929629593279 -0.0034662657448121525 -0.16437996929845952 -0.006004129868195164 0.03688282409580619 0.034903185780452775 -0.0010828646746416906 0.038234250305572426 0.0034866654926869658 -0.004541553911689557 -0.1634084261501946 -0.009089728658843783 0.037593396120821465; 0.001544317108050449 -0.15257742550842646 0.5032221284134658 -0.16601307222929634 0.03468569459451323 -0.0003227236454807039 -0.15603361420694836 0.003404272677989647 -0.0018706541640677189 0.03654366377401215 -0.002069782741692575 0.03654117505074832 0.03468680126131439 0.0016892556067786152 -0.1492259062343542 -6.164967903565497e-5; -0.15826706293908885 -0.00159029309841011 -0.15778023976270295 0.46555705577562784 0.0005482353387074051 0.037632153131398345 -0.002133263384687333 -0.1567586408572014 0.03132279699448781 -0.0017993561459100612 0.036497407031884456 0.00147401140884994 0.004153542379188969 0.03581342692279249 0.000681902981859809 -0.1577150211543164; -0.16327912018676052 -0.003972801810470209 0.03675262603025242 -0.0006208387011797067 0.50188002050342 -0.15980309033462356 -0.002379304268578439 -0.1543908575302831 -0.1501312505631193 0.0009692227295255948 0.03482791096741246 -0.005118612955001458 -0.0018589976659020855 0.03480610969650643 0.003224313646518338 0.03384092934372582; -0.001291204838009252 -0.147697038758823 0.00023018604121044866 0.03521082036258884 -0.15216739261435402 0.4816159716115183 -0.1502897119366858 -0.0031745035622491318 0.0022040950566254 -0.1591018959282234 -0.0017878943345419939 0.03589227906034795 0.033693195455238294 0.003362154936693168 0.032231727564796996 0.002028745913301199; 0.04001342794163592 -0.006993551226533814 -0.16079082152419455 -0.0043741761327866415 -0.004924498879078523 -0.16277949407760495 0.5166721724125727 -0.16477145217633254 0.0331640243940833 0.002464828141500214 -0.16168477708742995 -0.004786013535523511 0.003344096142851801 0.03629783554378077 -0.0037546701007679637 0.03720410216143906; -0.00023897687325199178 0.031739834065056816 -0.0010189093870493 -0.15554493499728536 -0.14889945089915826 -0.0013931230133652397 -0.14957564177647456 0.538160088615617 0.0033574986957033526 0.03643858101101029 -0.0031284253684252523 -0.15551790644627334 0.03356008826413147 0.0002292496365546849 0.03207630934007616 -0.0010779339587719961; 0.0005189241151761002 0.03569896564560611 -0.0027078526122727973 0.036700701959219456 -0.15893883813326024 0.0035700898984153667 0.0373204798824859 -0.00027849740630551495 0.4881235096796619 -0.17521504904012355 0.0067034489972692965 -0.1722697420370255 -0.1641940197112085 0.001479171388562691 0.03479748335510935 -0.00016789936977112653; 0.03328708242719776 -0.0022292184214812976 0.03360427687326456 -0.00017999900586420582 0.0009345312712633387 -0.146026559093337 0.0032270856425180637 0.03200297369828769 -0.14422651158934305 0.49718555125963293 -0.15146977935989925 0.004016341998689893 0.0018554072527900097 -0.1464689757659444 0.0005685316171704268 0.0328823121771512; 0.0005610925623709376 0.032499726210620083 0.000880417189412482 0.03469552002832708 0.03381036671119935 0.0026699505341205056 -0.1508708617221875 -0.0010879131416636342 0.0022978516074702014 -0.15941146055784833 0.49445220876879736 -0.1594033753406537 0.0356624414995798 0.001502473001194861 -0.14729883913610578 -0.002635672835872469; 0.033553625360264065 0.0031117753444331823 0.033585930261204176 0.0022877300718145504 -0.0019929148567897695 0.03225258977042406 -0.0009643853135129321 -0.14768221051226266 -0.1401030714266774 0.0015457701208019864 -0.14948675596829364 0.4750249742143213 0.0020832111632724513 0.0307433487200249 -0.0012375296766149915 -0.1494398494339179; -0.15336955536802718 -0.0033357701715413463 0.03423464450554684 0.003952996066706406 0.0003531603766002585 0.03328968955450143 0.0005179212144537495 0.03277958950609757 -0.14575193297748285 0.0002540985892658829 0.03489894120337061 8.43579294777186e-6 0.5096548821759187 -0.15494766455596287 -0.000482363869951617 -0.15675568099246326; -0.0007173109462336355 -0.14806231575170983 0.000683781420578844 0.035052577186546856 0.03495708791272884 0.002363804039370568 0.03358000578484016 -0.0007340129807579419 0.0036369829875461048 -0.16171205676354913 0.0009079035617771966 0.03675325615073621 -0.1614093912533202 0.476576180501131 -0.14777590425859985 -0.0021087321733276945; 0.03718701046356409 -0.008110575189421796 -0.15928602979707923 -0.0020833538704073513 0.0041811955165406735 0.03643878282831863 -0.004733304918929504 0.03756082712851952 0.032528906723373004 -0.0018792626376814736 -0.16239655127264122 0.000586241495952085 -0.0030520389686069767 -0.15927759521659055 0.5310600856182538 -0.16091738294994276; -0.002264631832972174 0.030666958318547596 -0.00031977932631581266 -0.15675730648887862 0.03331923957722532 0.001064174806003151 0.03243947002002744 0.0003023998580642915 -0.001469026609155824 0.036791483802729896 -0.002113962373845438 -0.15647796151676355 -0.15256958459493178 -0.0042733769646224 -0.13984676729889733 0.5174007428593363
    ] ≈ measured[:Greens].obs |> mean           atol=0.0001
    @test [
        0.019036309651313095 0.004275338756144346 0.0027322836869767392 0.006098666836121223 0.005152182403326186 0.002342448373840345 0.0021761729753334456 0.0028082116405910473 0.0022575620581491568 0.0015571786088503976 0.0016998977444620284 0.0015667358381430989 0.005387899882222259 0.0025272247116726945 0.0013097885169024942 0.001921189088387615; 0.005367516479841752 0.0161904477780313 0.006241513316141993 0.002351234708256202 0.0022198010904426256 0.005606667811426704 0.0024661226628342275 0.0014493790069285049 0.001875298716594868 0.0030715698656264044 0.0023730453964623055 0.001969392526843091 0.0023780478609732986 0.00674921331745317 0.0024779570032391267 0.0019921005132619825; 0.002458491243488174 0.006224390567074118 0.017947118144596135 0.007537561825151212 0.002093075231886631 0.002848683356726866 0.005997652959489218 0.002681510729453182 0.0018474643382295412 0.001944224794231408 0.002688483136935592 0.0017634657213136996 0.002169621093534926 0.002407881174684202 0.00504132840985848 0.0029311927912516376; 0.0048909913565231625 0.0027891086921042144 0.006684461021495238 0.014826527362087326 0.002279203611722843 0.0018996697083859403 0.002427591965968903 0.005244751689767832 0.001560715978271313 0.0019596091153937416 0.002052298758092644 0.0027309321641583017 0.002185841371256469 0.0017237705335293554 0.002270314915720237 0.005390881176746934; 0.006363727124689811 0.0024747787231799343 0.0020733886963051895 0.002226492682037634 0.017274627379869956 0.006778416349325635 0.002487446095738927 0.0044575557169768765 0.004821113270875786 0.002451806750645244 0.0017405567697183582 0.002319216002021558 0.0026031689420434635 0.0016858148643528964 0.001709177282943774 0.0014190304988554265; 0.0026707988110732644 0.00474392982960577 0.0026748418574992754 0.0018870261129214604 0.00619395352574788 0.015529197915268668 0.00486615287990137 0.0027461862709045543 0.0023643935022811054 0.00559182183037939 0.002545914694025881 0.001492816198492005 0.0018142457233731055 0.0025950177121035816 0.0014423544812366452 0.0018902190049541415; 0.0021066937139101517 0.002602257050733789 0.0063433496087753425 0.002881364622438398 0.002295080420305644 0.005802396675855488 0.01698988884225855 0.0074326826309579624 0.0015914287961616052 0.002364438409286418 0.0064777751298789096 0.0027859757997302096 0.0019318206065561706 0.0017848674421228586 0.0026124944984324905 0.002329859314022218; 0.0030155939167634655 0.0018811623274672667 0.0021193342097265365 0.005673828637511059 0.0060566051631781685 0.002577418620315891 0.0060678678883437365 0.017551803027349315 0.002017966865185776 0.0020331638914282612 0.002755944142884211 0.005637866774905871 0.001691660177528829 0.0016512832001637913 0.0017586921671544915 0.002441463157454773; 0.003194080063641556 0.0020296410229540102 0.001927679896256647 0.0019786941937908207 0.0056744842883902705 0.00253737338863646 0.0023650404715101054 0.0027546143757098966 0.0166780907662989 0.0073851221005937625 0.0025078837133804075 0.007373646876499854 0.0064628110519876015 0.0029511346895967185 0.001814330337761079 0.0025022457477321585; 0.001344238485269012 0.0019170079233164711 0.0019120863256700741 0.0015194200298218397 0.002141109787775361 0.004267295023739139 0.0022059530709299825 0.0013564156087778093 0.005532950615319382 0.016250001923804477 0.005579200483908451 0.002444188211382221 0.002396420626195038 0.004831990577677823 0.0019810217365404535 0.0016620722598285798; 0.0021844921675266827 0.0017821822872064318 0.002707865934796863 0.0018930490650442093 0.0015106572026585532 0.0022169824964418977 0.006279985224570267 0.002707184989403519 0.0025109463649847326 0.005880293915802058 0.015149687637628318 0.005057050695680422 0.002012347256652989 0.0023638954782739465 0.005538479554528282 0.002276645535210541; 0.0017208532918349595 0.0015874651085898937 0.0017274987770035195 0.0029542087942347347 0.002285965572601126 0.0014470288731124963 0.002259107822076488 0.005099207586692654 0.00490999391748333 0.002266467636466456 0.0057161571820036 0.016981962144626613 0.002085638669642133 0.0017365815749286724 0.0015071193020268277 0.0052142514926210035; 0.004902256544938452 0.0020737851263197328 0.0017307309465992113 0.002539403264143693 0.0025851060623688586 0.0015448157761172954 0.0022442628269559593 0.001507119502877877 0.0055401899498513 0.0022713083805696384 0.0020198143514409774 0.0026358465926791326 0.01818721557230038 0.006120522182349303 0.0023646394774796456 0.005934479064251138; 0.0030224578791886235 0.00520372710570183 0.002755975555112094 0.002043787453315336 0.0019413813197430906 0.002674990917020321 0.0017607727293324279 0.0018469456135621182 0.002577887295052279 0.004920463385631956 0.0026781438658960576 0.002162951932645222 0.00783364508855508 0.01746349815040598 0.005869543468904895 0.002908842935009184; 0.001959177525541311 0.0024428864285170808 0.006262659121319083 0.0024651161720712074 0.00182937732524748 0.00159605024147371 0.0028051510323782673 0.0021664965287707593 0.001529739364990348 0.00255555664925425 0.00562783448923425 0.001978862212401593 0.002879127598649168 0.006898041663060947 0.01732179843958681 0.006626344451829502; 0.002316205441169306 0.0014482403743486531 0.00253849301030143 0.0063372316078174045 0.0018633913153026532 0.001863897113357947 0.0019203802814192327 0.002857375919726855 0.0021526364720696246 0.0024253973749420715 0.0019505457843814755 0.005591294666977216 0.005559421935709496 0.002930549060657846 0.004853138482281587 0.01726606373995043
    ] ≈ measured[:Greens].obs |> std_error      atol=0.0001

    # Boson Energy
    @test  -0.300 ≈ measured[:BosonEnergy].obs |> mean          atol=0.001
    @test  0.416 ≈ measured[:BosonEnergy].obs |> std_error      atol=0.001

    # Configurations :conf
    @test [
        0.16 0.1 -0.04 -0.04 -0.12 0.06 0.14 -0.08 0.04 -0.12; -0.04 -0.24 -0.08 -0.2 -0.28 -0.3 -0.1 -0.06 0.0 0.16; -0.16 -0.1 0.18 0.1 -0.08 -0.1 0.2 0.18 -0.06 -0.1; 0.04 0.1 0.0 0.12 0.2 0.1 -0.04 0.1 -0.02 0.08; 0.1 -0.1 -0.08 -0.14 0.0 -0.08 0.06 -0.12 0.06 0.12; 0.22 0.04 -0.24 0.2 -0.1 0.06 0.02 -0.02 -0.16 0.24; -0.08 -0.02 -0.3 -0.08 0.08 0.02 0.12 -0.18 -0.06 0.1; -0.2 -0.02 0.04 -0.06 0.08 -0.12 -0.02 0.04 -0.16 -0.2; -0.1 -0.12 -0.08 0.14 0.08 0.02 0.02 0.14 0.12 0.14; 0.16 0.08 0.04 -0.02 0.08 -0.08 -0.14 0.02 -0.14 0.0; 0.08 -0.14 0.16 0.02 0.06 -0.12 -0.06 0.16 -0.06 0.0; 0.08 0.24 0.08 0.0 0.14 0.08 0.04 -0.14 0.04 -0.04; -0.06 0.0 0.06 -0.08 0.08 0.02 -0.08 -0.06 0.22 -0.2; 0.1 0.04 0.0 -0.06 0.04 0.02 0.24 -0.02 0.08 0.06; -0.16 -0.14 -0.18 -0.1 -0.1 0.0 -0.14 0.14 0.12 -0.1; 0.0 -0.02 0.0 0.08 -0.12 -0.06 -0.18 -0.1 0.14 -0.16
    ] ≈ [MonteCarlo.decompress(mc, m, c) for c in mc.configs] |> mean                    atol=0.01

    # Charge Density Correlation
    @test [
        1.5475639544924544, 0.9357147275890807, 0.9356142612712862, 0.9357147275890806, 0.9356142612712864, 0.9942520649617483, 0.9890339109627417, 0.9865241580609763, 1.0016167591618215, 0.9865241580609763, 0.989033910962742, 0.9879509583797096, 0.9879509583797096, 0.9845001897680479, 0.9845001897680479, 0.9956993671839532
    ][:] ≈ mean(measured[:CDC])
    @test [
        0.013869638657504228, 0.013470915194620922, 0.013282700278496358, 0.013470915194621087, 0.013282700278496358, 0.013550942726610091, 0.014307471098069393, 0.014492552221530538, 0.014129517405169136, 0.01449255222153069, 0.014307471098069393, 0.013948472512305249, 0.01394847251230509, 0.01389084520478554, 0.01389084520478546, 0.013133272694007561
    ][:] ≈ std_error(measured[:CDC])

    # Spin density correlations (x, y, z)
    @test [
        0.4429653314717919, -0.04370216965399458, -0.043612330295362885, -0.04370216965399458, -0.04361233029536289, -0.000946359143464255, -0.0008341145546385382, -0.0009155800316996598, -0.0010002441809075038, -0.0009155800316996598, -0.0008341145546385382, -0.00201357312086348, -0.00201357312086348, -0.0020135699303120863, -0.0020135699303120867, -0.000515078257581753
    ][:] ≈ mean(measured[:SDC].x)
    @test [
        0.0015350907401287547, 0.0002368878415500336, 0.0002607507287443457, 0.0002368878415500336, 0.00026075072874433736, 6.64636472973452e-5, 2.9316744933934093e-5, 3.521865202114811e-5, 6.282380159287888e-5, 3.521865202114811e-5, 2.931674493393406e-5, 2.5828399958572843e-5, 2.5828399958573172e-5, 2.7096518574704045e-5, 2.7096518574704045e-5, 2.605149773144738e-5
    ][:] ≈ std_error(measured[:SDC].x)
    @test [
        0.4429653314717919, -0.04370216965399458, -0.043612330295362885, -0.04370216965399458, -0.04361233029536289, -0.000946359143464255, -0.0008341145546385382, -0.0009155800316996598, -0.0010002441809075038, -0.0009155800316996598, -0.0008341145546385382, -0.00201357312086348, -0.00201357312086348, -0.0020135699303120863, -0.0020135699303120867, -0.000515078257581753
    ][:] ≈ mean(measured[:SDC].y)
    @test [
        0.0015350907401287547, 0.0002368878415500336, 0.0002607507287443457, 0.0002368878415500336, 0.00026075072874433736, 6.64636472973452e-5, 2.9316744933934093e-5, 3.521865202114811e-5, 6.282380159287888e-5, 3.521865202114811e-5, 2.931674493393406e-5, 2.5828399958572843e-5, 2.5828399958573172e-5, 2.7096518574704045e-5, 2.7096518574704045e-5, 2.605149773144738e-5
    ][:] ≈ std_error(measured[:SDC].y)
    @test [
        0.4429653314717919, -0.04370216965399458, -0.043612330295362885, -0.04370216965399457, -0.04361233029536289, -0.0009463591434642553, -0.0008341145546385382, -0.0009155800316996598, -0.0010002441809075038, -0.0009155800316996595, -0.0008341145546385383, -0.0020135731208634792, -0.0020135731208634797, -0.0020135699303120867, -0.0020135699303120863, -0.0005150782575817528
    ][:] ≈ mean(measured[:SDC].z)
    @test [
        0.0015350907401287547, 0.00023688784155001527, 0.00026075072874433736, 0.00023688784155001527, 0.0002607507287443457, 6.64636472973453e-5, 2.9316744933933842e-5, 3.521865202114802e-5, 6.282380159287893e-5, 3.521865202114805e-5, 2.931674493393381e-5, 2.58283999585735e-5, 2.5828399958572843e-5, 2.7096518574704045e-5, 2.7096518574704357e-5, 2.605149773144732e-5
    ][:] ≈ std_error(measured[:SDC].z)

    # Pairing Correlations
    @test [
        0.025073002716459472, 0.02177107066116464, 0.021841528506071285, 0.021771070661164647, 0.021841528506071285, 0.022162032782035827, 0.0220529324416837, 0.022018704329825618, 0.022269276688461893, 0.022018704329825618, 0.022052932441683697, 0.02207690961651873, 0.022076909616518727, 0.02201800987168783, 0.022018009871687835, 0.022222747414707422
    ] ≈ mean(measured[:PC])
    @test [
        0.0002105127183495801, 0.00023385653804923551, 0.0002278443811861535, 0.00023385653804923088, 0.0002278443811861535, 0.00024080631539074356, 0.000224780396529855, 0.00020996058488898168, 0.0002260538652773379, 0.00020996058488897653, 0.000224780396529855, 0.00022103145904403207, 0.00022103145904403207, 0.00022216598969535637, 0.00022216598969534662, 0.00025261546247757943
    ] ≈ std_error(measured[:PC])
end



# TODO
# remove this / make this an example / make this faster
#=


"""
    stat_equal(
        expected_value, actual_values, standard_errors;
        min_error = 0.1^3, order=2, rtol = 0, debug=false
    )

Compare an `expected_value` (i.e. literature value, exact result, ...) to a set
of `actual_values` and `standard_errors` (i.e. calculated from DQMC or MC).

- `order = 2`: Sets the number of σ-intervals included. (This affects the
accuracy of the comaprison and the number of matches required)
- `min_error = 0.1^3`: Sets a lower bound for the standard error. (If one
standard error falls below `min_error`, `min_error` is used instead. This
happens before `order` is multiplied.)
- `rtol = 0`: The relative tolerance passed to `isapprox`.
- `debug = false`: If `debug = true` information on comparisons is always printed.
"""
function stat_equal(
        expected_value, actual_values::Vector, standard_errors::Vector;
        min_error = 0.001, order=2, debug=false, rtol=0.0
    )

    @assert order > 1
    N_matches = floor(length(actual_values) * (1 - 1 / order^2))
    if N_matches == 0
        error("No matches required. Try increasing the sample size or σ-Interval")
    elseif N_matches < 3
        @warn "Only $N_matches out of $(length(actual_values)) are required!"
    end

    is_approx_equal = [
        isapprox(expected_value, val, atol=order * max(min_error, err), rtol=rtol)
        for (val, err) in zip(actual_values, standard_errors)
    ]
    does_match = sum(is_approx_equal) >= N_matches

    if debug || !does_match
        printstyled("────────────────────────────────\n", color = :light_magenta)
        print("stat_equal returned ")
        printstyled("$(does_match)\n\n", color = does_match ? :green : :red)
        print("expected: $expected_value\n")
        print("values:   [")
        for i in eachindex(actual_values)
            if i < length(actual_values)
                printstyled("$(actual_values[i])", color = is_approx_equal[i] ? :green : :red)
                print(", ")
            else
                printstyled("$(actual_values[i])", color = is_approx_equal[i] ? :green : :red)
            end
        end
        print("]\n")
        print("$(order)-σ:      [")
        for i in eachindex(standard_errors)
            if i < length(standard_errors)
                printstyled("$(standard_errors[i])", color = is_approx_equal[i] ? :green : :red)
                print(", ")
            else
                printstyled("$(standard_errors[i])", color = is_approx_equal[i] ? :green : :red)
            end
        end
        print("]\n")
        print("checks:   [")
        for i in eachindex(standard_errors)
            if i < length(standard_errors)
                printstyled("$(is_approx_equal[i])", color = is_approx_equal[i] ? :green : :red)
                print(", ")
            else
                printstyled("$(is_approx_equal[i])", color = is_approx_equal[i] ? :green : :red)
            end
        end
        print("]\n")
        printstyled("────────────────────────────────\n", color = :light_magenta)
    end
    does_match
end



@testset "DQMC: triangular Hubbard model vs dos Santos Paper" begin
    # > Attractive Hubbard model on a triangular lattice
    # dos Santos
    # https://journals.aps.org/prb/abstract/10.1103/PhysRevB.48.3976
    Random.seed!()
    sample_size = 5

    @time for (k, (mu, lit_oc, lit_pc,  beta, L)) in enumerate([
            (-2.0, 0.12, 1.0,  5.0, 4),
            (-1.2, 0.48, 1.50, 5.0, 4),
            ( 0.0, 0.88, 0.95, 5.0, 4),
            ( 1.2, 1.25, 1.55, 5.0, 4),
            ( 2.0, 2.00, 0.0,  5.0, 4)

            # (-2.0, 0.12, 1.0,  8.0, 4),
            # (-1.2, 0.48, 1.82, 8.0, 4),
            # ( 0.0, 0.88, 0.95, 8.0, 4),
            # ( 1.2, 1.25, 1.65, 8.0, 4),
            # ( 2.0, 2.00, 0.0,  8.0, 4),

            # (-2.0, 0.40, 1.0,  5.0, 6),
            # (-1.2, 0.40, 1.05, 5.0, 6),
            # (0.01, 0.80, 1.75, 5.0, 6),
            # ( 1.2, 1.40, 2.0,  5.0, 6),
            # ( 2.0, 2.00, 0.0,  5.0, 6)
        ])
        @info "[$(k)/5] μ = $mu (literature check)"
        m = HubbardModelAttractive(
            dims=2, L=L, l = MonteCarlo.TriangularLattice(L),
            t = 1.0, U = 4.0, mu = mu
        )
        OC_sample = []
        OC_errors = []
        PC_sample = []
        PC_errors = []
        for i in 1:sample_size
            mc = DQMC(
                m, beta=5.0, delta_tau=0.125, safe_mult=8,
                thermalization=2000, sweeps=2000, measure_rate=1,
                measurements = Dict{Symbol, MonteCarlo.AbstractMeasurement}()
            )
            push!(mc, :G => MonteCarlo.GreensMeasurement)
            push!(mc, :PC => MonteCarlo.PairingCorrelationMeasurement)
            run!(mc, verbose=false)
            measured = measurements(mc)

            # mean(measured[:G]) = MC mean
            # diag gets c_i c_i^† terms
            # 2 (1 - mean(c_i c_i^†)) = 2 mean(c_i^† c_i) where 2 follows from 2 spins
            occupation = 2 - 2(measured[:G].obs |> mean |> diag |> mean)
            push!(OC_sample, occupation)
            push!(OC_errors, 2(measured[:G].obs |> std_error |> diag |> mean))
            push!(PC_sample, measured[:PC].uniform_fourier |> mean)
            push!(PC_errors, measured[:PC].uniform_fourier |> std_error)
        end
        # min_error should compensate read-of errors & errors in the results
        # dos Santos used rather few sweeps, which seems to affect PC peaks strongly
        @test stat_equal(lit_oc, OC_sample, OC_errors, min_error=0.025)
        @test stat_equal(lit_pc, PC_sample, PC_errors, min_error=0.05)
    end
end

=#
