import Dispatch
import Quick
import Nimble

#if USE_COMBINE
import Combine
#elseif SWIFT_PACKAGE
import CombineX
#else
import Specs
#endif

#if USE_COMBINE
typealias OptionalPublisher<Wrapped> = Optional<Wrapped>.Publisher
#else
typealias OptionalPublisher<Wrapped> = Optional<Wrapped>.CombineX.Publisher
#endif

class OptionalSpec: QuickSpec {
    
    override func spec() {
        
        afterEach {
            Resources.release()
        }
        
        // MARK: - Send Values
        describe("Send Values") {
            
            // MARK: 1.1 should send a value then send finished
            it("should send value then send finished") {
                let pub = OptionalPublisher<Int>(1)
                
                let sub = makeTestSubscriber(Int.self, Never.self, .unlimited)
                pub.subscribe(sub)
                
                expect(sub.events).to(equal([.value(1), .completion(.finished)]))
            }
            
            // MARK: 1.2 should send finished even no demand
            it("should send finished") {
                let pub = OptionalPublisher<Int>(nil)
             
                let sub = makeTestSubscriber(Int.self, Never.self, .none)
                pub.subscribe(sub)
                
                expect(sub.events).to(equal([.completion(.finished)]))
            }
            
            #if !SWIFT_PACKAGE
            // MARK: 1.3 should throw assertion when none demand is requested
            it("should throw assertion when less than one demand is requested") {
                let pub = OptionalPublisher<Int>(1)
                let sub = makeTestSubscriber(Int.self, Never.self, .none)
                expect {
                    pub.subscribe(sub)
                }.to(throwAssertion())
            }
            
            // MARK: 1.4 should not throw assertion when none demand is requested if is nil
            it("should not throw assertion when none demand is requested if is nil") {
                let pub = OptionalPublisher<Int>(nil)
                let sub = makeTestSubscriber(Int.self, Never.self, .none)
                expect {
                    pub.subscribe(sub)
                }.toNot(throwAssertion())
            }
            #endif
        }
    }
}