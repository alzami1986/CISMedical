load finalXFullSignal
load finalYFullSignal

percent_vector = 10:10:100;
for i = 1:10
    percent = percent_vector(i);
    NewRUSBoostClassifier
end

load finalXFullSignal3
load finalYFullSignal3
for i = 1:10
    percent = percent_vector(i);
    NewRUSBoostClassifier
end

load finalXFullSignal2
load finalYFullSignal2
for i = 1:10
    percent = percent_vector(i);
    NewRUSBoostClassifier
end

