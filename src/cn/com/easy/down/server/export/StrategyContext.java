package cn.com.easy.down.server.export;

public class StrategyContext {
    private Strategy strategy = null;
	public StrategyContext(Strategy _strategy){
		this.strategy = _strategy;
	} 
	public String export(ArgsBean args) throws Exception{
		return this.strategy.export(args);
	}
}