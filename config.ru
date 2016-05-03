Dir.glob('./{controllers}/init.rb').each do |file|
	require file
end

run ShareConfigurationsApp