import SwiftUI
import Models

// Database model for dream articles
struct DreamArticle: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let link: String
    let category: ArticleCategory
    let content: String
    let images: [String]
    
    enum ArticleCategory: String, CaseIterable {
        case science = "Science"
        case techniques = "Techniques"
        case psychology = "Psychology"
        case symbols = "Symbols"
        case research = "Research"
    }
    
    static let allArticles: [DreamArticle] = [
        DreamArticle(
            icon: "moon.stars.fill",
            title: "Understanding REM Sleep",
            description: "Learn how REM sleep affects dreaming and memory consolidation",
            link: "https://example.com/rem-sleep",
            category: .science,
            content: """
            # Understanding REM Sleep
            
            Rapid Eye Movement (REM) sleep is one of the most fascinating stages of the sleep cycle and is closely associated with dreaming. During this stage, your brain becomes almost as active as when you're awake, while your body remains in a state of temporary paralysis.
            
            ## The Science Behind REM Sleep
            
            REM sleep typically first occurs about 90 minutes after falling asleep and recurs every 90 minutes throughout the night, with episodes lengthening as the night progresses. During REM sleep:
            
            - Your brain activity increases dramatically
            - Your eyes move rapidly behind closed lids
            - Heart rate and breathing become irregular
            - Your body experiences temporary muscle atonia (paralysis)
            
            ## REM Sleep and Dreaming
            
            The majority of vivid, narrative dreams occur during REM sleep. Scientists believe this is because the brain is processing and integrating information from the day, creating new neural connections, and encoding memories.
            
            ## Memory Consolidation
            
            REM sleep plays a crucial role in memory consolidation, particularly for procedural memory (how to do things) and emotional memory. During REM sleep, the brain:
            
            - Strengthens neural connections for newly learned information
            - Processes emotional experiences
            - Enhances creative problem-solving abilities
            
            ## Sleep Cycles and REM Sleep
            
            A typical night's sleep consists of 4-6 sleep cycles, each containing periods of NREM (non-REM) and REM sleep. As the night progresses, REM periods become longer while NREM periods shorten.
            
            Understanding the importance of REM sleep can help you appreciate why getting a full night's sleep is essential for cognitive function, emotional regulation, and overall well-being.
            """,
            images: ["rem_sleep_graph", "brain_activity", "sleep_cycle"]
        ),
        DreamArticle(
            icon: "brain.head.profile",
            title: "The Science of Nightmares",
            description: "Explore the psychological and neurological causes of nightmares",
            link: "https://example.com/nightmares",
            category: .psychology,
            content: """
            # The Science of Nightmares
            
            Nightmares are disturbing dreams that cause feelings of fear, terror, distress, or anxiety. They typically occur during REM sleep and can feel intensely real while they're happening. Nightmares affect people of all ages but are especially common in children.
            
            ## Neurological Causes of Nightmares
            
            From a neurological perspective, nightmares involve several brain regions:
            
            - The amygdala, which processes fear responses, becomes highly active
            - The prefrontal cortex, which normally provides rational thought, is less active during REM sleep
            - The visual cortex generates vivid imagery
            - The limbic system processes intense emotions
            
            ## Psychological Factors
            
            Several psychological factors can contribute to nightmares:
            
            - Stress and anxiety
            - Traumatic experiences (leading to trauma nightmares or PTSD nightmares)
            - Major life changes or significant emotional experiences
            - Sleep deprivation
            
            ## Nightmare Disorder
            
            When nightmares become frequent and severe enough to cause distress or impair daily functioning, a person may be diagnosed with nightmare disorder. This condition affects approximately 4% of adults.
            
            ## Managing Nightmares
            
            Effective strategies for managing nightmares include:
            
            - Maintaining good sleep hygiene
            - Stress reduction techniques
            - Image rehearsal therapy (reimagining the nightmare with a different outcome)
            - Creating a relaxing bedtime routine
            - In some cases, therapy or medication may be recommended
            
            Understanding the science behind nightmares can help reduce their impact and provide strategies for managing them effectively.
            """,
            images: ["brain_nightmare", "rem_activity", "stress_factors"]
        ),
        DreamArticle(
            icon: "bed.double.fill",
            title: "Dream Journaling Methods",
            description: "Effective techniques to record and remember your dreams",
            link: "https://example.com/dream-journaling",
            category: .techniques,
            content: """
            # Dream Journaling Methods
            
            Dream journaling is the practice of recording your dreams shortly after waking. This practice not only helps you remember more dreams but can also increase dream recall, enhance self-awareness, and potentially lead to lucid dreaming.
            
            ## Why Keep a Dream Journal?
            
            Regular dream journaling offers numerous benefits:
            
            - Improved dream recall
            - Identification of recurring dream themes
            - Recognition of dream signs that can facilitate lucid dreaming
            - Greater self-understanding and psychological insight
            - A record of your subconscious mind's activity
            
            ## Effective Dream Journaling Techniques
            
            ### 1. Prepare Before Sleep
            
            - Place your journal and pen beside your bed
            - Set an intention to remember your dreams
            - Avoid alcohol and sleep medications that suppress REM sleep
            
            ### 2. Record Immediately Upon Waking
            
            - Write down dream memories as soon as you wake, even in the middle of the night
            - Record fragments if you can't remember entire dreams
            - Use a voice recorder as an alternative if writing is difficult
            
            ### 3. What to Record
            
            - Date and time
            - Dream narrative and events
            - Emotions felt during the dream
            - Sensory details (colors, sounds, smells, etc.)
            - Dream characters and their significance
            - Any symbols or recurring themes
            
            ### 4. Dream Analysis
            
            After recording the factual aspects of your dream, consider:
            
            - Possible meanings or connections to your waking life
            - Recurring symbols and what they might represent
            - How the dream made you feel upon waking
            
            With consistent practice, dream journaling can transform your relationship with your dreams and provide valuable insights into your subconscious mind.
            """,
            images: ["dream_journal", "journaling_methods", "dream_recall"]
        ),
        DreamArticle(
            icon: "sparkles",
            title: "Lucid Dreaming for Beginners",
            description: "Simple steps to start controlling your dreams consciously",
            link: "https://example.com/lucid-dreaming-basics",
            category: .techniques,
            content: """
            # Lucid Dreaming for Beginners
            
            Lucid dreaming is the remarkable experience of becoming aware that you're dreaming while still in the dream. This awareness opens the possibility to consciously influence or even control the dream's content and narrative.
            
            ## What is Lucid Dreaming?
            
            A lucid dream occurs when you realize you're dreaming during the dream itself. This realization can happen spontaneously or as a result of intentional practice. Once lucid, many dreamers can:
            
            - Control dream characters and environments
            - Overcome fears in a safe space
            - Practice skills
            - Experience impossible scenarios
            - Explore creative ideas
            
            ## Techniques for Beginners
            
            ### 1. Reality Testing
            
            Perform regular reality checks during your waking hours:
            - Try to push your finger through your palm
            - Check if text remains stable when you look away and back
            - Attempt to breathe with your nose pinched
            - Look at your hands or a digital clock
            
            These tests will become habitual and eventually occur in your dreams, triggering lucidity.
            
            ### 2. Keep a Dream Journal
            
            Record your dreams immediately upon waking to:
            - Improve dream recall
            - Identify personal dream signs
            - Notice recurring patterns
            
            ### 3. MILD Technique (Mnemonic Induction of Lucid Dreams)
            
            Before sleep:
            - Review a recent dream
            - Identify something unusual that could have triggered lucidity
            - Repeat an intention: "The next time I'm dreaming, I will remember I'm dreaming"
            - Visualize becoming lucid in that dream
            
            ### 4. WBTB (Wake Back to Bed)
            
            - Sleep for 5-6 hours
            - Wake up and stay awake for 30-60 minutes
            - Return to sleep while focusing on your intention to lucid dream
            
            ### 5. Start Small
            
            Once lucid:
            - First, stabilize the dream by rubbing your hands or spinning
            - Make small changes before attempting major control
            - Stay calm to avoid waking up from excitement
            
            With patience and practice, lucid dreaming can become a regular and enriching part of your sleep experience.
            """,
            images: ["lucid_dream", "reality_testing", "dream_control"]
        ),
        DreamArticle(
            icon: "figure.mind.and.body",
            title: "Dreams and Emotional Healing",
            description: "How dreams can help process emotions and support mental health",
            link: "https://example.com/emotional-healing",
            category: .psychology,
            content: """
            # Dreams and Emotional Healing
            
            Dreams serve as a natural mechanism for emotional processing and healing. During sleep, particularly REM sleep, our brains process unresolved emotions and experiences from our waking lives, potentially supporting psychological well-being and emotional resilience.
            
            ## How Dreams Process Emotions
            
            During dreaming, several important emotional processes occur:
            
            - The brain processes emotional experiences in a safe, virtual environment
            - Emotional memories are integrated with existing knowledge
            - Difficult emotions can be processed without the full stress response of waking life
            - The amygdala (emotional center) is highly active while the prefrontal cortex (rational thinking) is less active
            
            ## Therapeutic Functions of Dreams
            
            Dreams can serve several therapeutic functions:
            
            ### 1. Emotional Regulation
            
            Dreams help regulate emotions by processing difficult feelings in a controlled setting, potentially reducing emotional reactivity in waking life.
            
            ### 2. Fear Extinction
            
            Repetitive dreams about traumatic or frightening events may help the brain gradually reduce the fear response associated with these memories.
            
            ### 3. Problem-Solving
            
            Creative connections made during dreams can offer new perspectives on emotional challenges.
            
            ### 4. Memory Integration
            
            Dreams help integrate emotional experiences into long-term memory in ways that are less distressing.
            
            ## Working with Dreams for Emotional Healing
            
            Several approaches can enhance the healing potential of dreams:
            
            - Dream journaling to track emotional patterns
            - Dream analysis to uncover underlying feelings
            - Imagery rehearsal therapy for recurrent nightmares
            - Lucid dreaming to consciously engage with dream scenarios
            
            ## Clinical Applications
            
            Mental health professionals increasingly recognize the value of dreamwork in therapy:
            
            - In trauma treatment for PTSD
            - For anxiety and depression management
            - In grief processing
            - For exploring subconscious patterns that affect relationships
            
            By understanding and working with our dreams, we can tap into the brain's natural mechanisms for emotional processing and healing.
            """,
            images: ["emotional_healing", "brain_emotions", "dream_therapy"]
        ),
        DreamArticle(
            icon: "eye.fill",
            title: "Dream Symbols Across Cultures",
            description: "Comparative study of dream interpretation in different societies",
            link: "https://example.com/cultural-symbols",
            category: .symbols,
            content: """
            # Dream Symbols Across Cultures
            
            Dream symbols and their interpretations vary widely across different cultures and historical periods. While some symbolic elements appear consistently across cultures, their meanings are often shaped by specific cultural contexts, beliefs, and traditions.
            
            ## Universal and Cultural Dream Symbols
            
            ### Water
            - Western: Often represents emotions or the unconscious
            - Chinese: Associated with wealth and prosperity
            - Islamic: Clean water symbolizes life and knowledge
            - Native American: Connected to spiritual purification and healing
            
            ### Animals
            - European: Different animals represent specific traits (fox: cunning, lion: courage)
            - African: Animals often represent ancestral spirits or guides
            - Tibetan: Animals may represent aspects of self that need integration
            - Australian Aboriginal: Animals connect to ancestral Dreamtime stories
            
            ### Flying
            - Western: Freedom, transcendence, or escape
            - Hindu: Spiritual advancement
            - Japanese: Good fortune
            - Ancient Egyptian: The soul's journey
            
            ### Teeth
            - North American: Anxiety about appearance or communication
            - Chinese: Dreams of losing teeth may predict family misfortune
            - Middle Eastern: Can represent family members or longevity
            - Brazilian: Often connected to financial concerns
            
            ## Historical Perspectives on Dream Interpretation
            
            Different historical periods have developed unique approaches to dream interpretation:
            
            - Ancient Mesopotamian: Dreams as divine messages
            - Classical Greek: Dreams as health indicators or prophetic visions
            - Medieval European: Religious significance and moral lessons
            - Indigenous American: Dreams as reality equal to waking life
            - Modern Western: Psychological and personal significance
            
            ## Contemporary Cross-Cultural Dream Research
            
            Recent research has revealed interesting patterns:
            
            - Universal dream themes exist (falling, being chased, flying)
            - Cultural context significantly influences dream content
            - Technological advancement affects dream imagery across cultures
            - Cultural values shape emotional responses to similar dream events
            
            Understanding how dream symbols vary across cultures enhances our appreciation of both the universal aspects of human dreaming and the rich diversity of human experience.
            """,
            images: ["cultural_symbols", "global_dreams", "symbolic_meanings"]
        ),
        DreamArticle(
            icon: "clock.fill",
            title: "Circadian Rhythms and Dreams",
            description: "The relationship between your body clock and dream patterns",
            link: "https://example.com/circadian-rhythms",
            category: .science,
            content: """
            # Circadian Rhythms and Dreams
            
            Circadian rhythms—our internal 24-hour biological clocks—significantly influence when and how we dream. Understanding this relationship can help optimize sleep quality and potentially enhance dream experiences.
            
            ## The Basics of Circadian Rhythms
            
            Circadian rhythms regulate numerous physiological processes including:
            
            - Sleep-wake cycles
            - Hormone production (especially melatonin and cortisol)
            - Body temperature fluctuations
            - Cognitive performance patterns
            
            These rhythms are primarily controlled by the suprachiasmatic nucleus (SCN) in the hypothalamus, which responds to light exposure through the eyes.
            
            ## How Circadian Rhythms Affect Dreams
            
            ### Dream Timing and REM Sleep
            
            - REM sleep, when most vivid dreaming occurs, follows a circadian pattern
            - REM episodes are longer and dreams more intense in the latter part of the night
            - The first REM period typically occurs about 90 minutes after falling asleep
            - Morning REM periods can last up to an hour, producing longer, more complex dreams
            
            ### Circadian Disruption and Dream Effects
            
            When circadian rhythms are disrupted (through shift work, jet lag, or irregular sleep schedules):
            
            - REM sleep may be reduced or fragmented
            - Dream recall often decreases
            - Dream content may become more emotionally negative
            - Sleep onset REM periods (SOREMPs) may occur, leading to hypnagogic hallucinations
            
            ## Optimizing Circadian Rhythms for Better Dreams
            
            Several strategies can help align circadian rhythms for optimal dreaming:
            
            - Maintain consistent sleep-wake times, even on weekends
            - Get bright light exposure in the morning
            - Limit blue light from screens before bedtime
            - Time exercise appropriately (morning or afternoon, not close to bedtime)
            - Consider melatonin supplementation if recommended by a healthcare provider
            
            ## Chronotypes and Dreaming
            
            Individual chronotypes ("morning larks" vs. "night owls") may experience dreams differently:
            
            - Early chronotypes often report more positive dream content
            - Evening chronotypes may have more vivid and unusual dreams
            - Dream recall ability varies by chronotype
            
            Understanding your personal circadian rhythm and its effects on your dream life can help you cultivate more meaningful dream experiences and better overall sleep quality.
            """,
            images: ["circadian_clock", "rem_timing", "sleep_cycle_chart"]
        ),
        DreamArticle(
            icon: "book.closed.fill",
            title: "Famous Dream Theories",
            description: "Exploring theories from Freud, Jung, and modern neuroscience",
            link: "https://example.com/dream-theories",
            category: .psychology,
            content: """
            # Famous Dream Theories
            
            Throughout history, prominent thinkers have proposed various theories to explain why we dream and what our dreams might mean. From psychoanalytic perspectives to modern neuroscientific models, these theories offer diverse lenses through which to understand the enigmatic world of dreams.
            
            ## Freudian Dream Theory
            
            Sigmund Freud's theory, outlined in his 1900 work "The Interpretation of Dreams," proposed that dreams primarily serve as wish fulfillment.
            
            Key concepts:
            - Dreams represent unconscious desires, often sexual or aggressive
            - "Manifest content" (what we remember) disguises the "latent content" (hidden meaning)
            - Dream censorship transforms unacceptable wishes into symbolic imagery
            - Dreams provide a "royal road to the unconscious"
            
            ## Jungian Dream Theory
            
            Carl Jung developed analytical psychology, which viewed dreams differently from Freud's approach.
            
            Key concepts:
            - Dreams compensate for imbalances in the conscious mind
            - Dreams contain personal and collective unconscious material
            - "Archetypes" (universal symbolic patterns) appear in dreams
            - Dreams guide individuation (psychological integration and wholeness)
            
            ## Activation-Synthesis Theory
            
            Developed by J. Allan Hobson and Robert McCarley in 1977, this neuroscientific approach challenged psychoanalytic views.
            
            Key concepts:
            - Dreams result from the brain's attempt to make sense of random neural activity during REM sleep
            - The forebrain synthesizes a narrative from chaotic brainstem signals
            - Dreams don't necessarily have hidden meanings
            - Dream imagery reflects the brain's attempt to interpret internal signals
            
            ## Threat Simulation Theory
            
            Proposed by Antti Revonsuo, this evolutionary perspective suggests dreams serve a survival function.
            
            Key concepts:
            - Dreams simulate threatening situations in a safe environment
            - This provides rehearsal for real-life dangers
            - Explains prevalence of chase and attack themes in dreams
            - Dreams evolved as a defense mechanism for survival
            
            ## Contemporary Neurocognitive Models
            
            Modern dream research integrates various perspectives:
            
            - Memory consolidation: Dreams help process and integrate memories
            - Emotional regulation: Dreams process emotional experiences
            - Default network activation: Dreams engage similar brain networks as daydreaming
            - Predictive coding: Dreams help the brain model potential future scenarios
            
            Each theory captures important aspects of dreaming, and contemporary research increasingly suggests that dreams likely serve multiple functions simultaneously, from emotional processing to memory consolidation and beyond.
            """,
            images: ["freud_jung", "brain_activity", "theory_comparison"]
        ),
        DreamArticle(
            icon: "waveform.path.ecg",
            title: "Sleep Disorders and Dreaming",
            description: "How various sleep disorders affect dream experiences",
            link: "https://example.com/sleep-disorders",
            category: .science,
            content: """
            # Sleep Disorders and Dreaming
            
            Sleep disorders can significantly alter dream experiences, sometimes creating unusual or disturbing dream phenomena. Understanding these connections can help in diagnosis and treatment of sleep conditions.
            
            ## Insomnia and Dreaming
            
            People with insomnia often report:
            - Reduced dream recall due to fragmented REM sleep
            - More negative dream content
            - Dreams about the inability to sleep
            - Heightened emotional reactivity to dream content
            
            Cognitive behavioral therapy for insomnia (CBT-I) can improve both sleep quality and normalize dream experiences.
            
            ## Sleep Apnea
            
            This breathing disorder causes multiple awakenings and can affect dreams:
            - Disturbing dreams of choking or suffocation (mirroring the actual breathing difficulties)
            - Fragmented dream narratives due to sleep disruption
            - Reduced dream recall
            - Dreams may improve significantly with CPAP treatment
            
            ## Narcolepsy and REM Abnormalities
            
            Narcolepsy, a neurological disorder, profoundly affects REM sleep and dreaming:
            - Hypnagogic hallucinations (dream-like experiences when falling asleep)
            - Hypnopompic hallucinations (dream-like experiences when waking up)
            - Sleep paralysis (inability to move during dream-wake transitions)
            - Unusually vivid and often frightening dreams
            - REM sleep behavior disorder may co-occur (physically acting out dreams)
            
            ## Parasomnias and Dreaming
            
            Parasomnias involve unusual behaviors during sleep:
            
            ### REM Sleep Behavior Disorder (RBD)
            - Lack of normal muscle paralysis during REM sleep
            - Physically acting out dreams, sometimes resulting in injury
            - Dreams often involve defending oneself from attack
            - May be an early sign of neurodegenerative conditions like Parkinson's
            
            ### Night Terrors
            - Occur during non-REM sleep
            - Not actually dreams but appear similar
            - Intense fear with screaming and autonomic arousal
            - Limited or no recall of the event
            
            ### Sleepwalking
            - Occurs in non-REM sleep
            - Complex behaviors without conscious awareness
            - Not associated with dream content
            - May be triggered by sleep deprivation or stress
            
            ## Medications and Dream Effects
            
            Many medications alter dream experiences:
            - Beta-blockers: Often cause nightmares
            - Antidepressants: Can suppress or intensify dreams
            - Sedatives: May reduce dream recall
            - Dopamine agonists: Can cause vivid or unusual dreams
            
            Understanding the relationship between sleep disorders and dream experiences can provide valuable diagnostic insights and help monitor treatment effectiveness.
            """,
            images: ["sleep_disorders", "rem_disorders", "dream_disruption"]
        ),
        DreamArticle(
            icon: "gear.badge",
            title: "Technology and Dream Research",
            description: "Modern tools and apps that help study and enhance dreams",
            link: "https://example.com/dream-technology",
            category: .research,
            content: """
            # Technology and Dream Research
            
            Advances in technology are revolutionizing how scientists study dreams and how individuals can interact with their dream experiences. From sophisticated laboratory equipment to consumer apps, these tools are opening new frontiers in dream research and practice.
            
            ## Scientific Research Technologies
            
            ### Neuroimaging During Sleep
            
            - fMRI (functional Magnetic Resonance Imaging): Captures brain activity during dreams
            - EEG (Electroencephalography): Records electrical activity and identifies sleep stages
            - PET (Positron Emission Tomography): Measures metabolic activity during REM sleep
            - Near-infrared spectroscopy: Non-invasive monitoring of brain activity during sleep
            
            These technologies have revealed that:
            - Specific dream content correlates with activity in particular brain regions
            - Visual dreams activate similar brain areas as waking vision
            - Emotional content in dreams corresponds with limbic system activity
            
            ### Dream Content Analysis
            
            - AI text analysis of dream reports identifies patterns and themes
            - Machine learning algorithms categorize dream elements across large datasets
            - Computational linguistics techniques extract emotional content from dream narratives
            
            ## Consumer Technologies for Dreams
            
            ### Dream Recording and Enhancement
            
            - EEG headbands designed for home use
            - Smart alarm clocks that wake users during optimal dream recall periods
            - Audio recording apps activated by sleep talking
            - Dream journaling apps with pattern recognition
            
            ### Lucid Dream Induction Devices
            
            - Light-emitting sleep masks that provide visual cues during REM
            - Wearables that detect REM sleep and deliver subtle stimuli
            - Transcranial direct current stimulation (tDCS) devices
            - Audio headbands that play cues when REM is detected
            
            ## Emerging Research Directions
            
            ### Two-way Communication with Dreamers
            
            Recent breakthrough studies have demonstrated:
            - Lucid dreamers can respond to questions from researchers while dreaming
            - Dreamers can solve simple math problems and communicate answers
            - This opens possibilities for interactive dream research
            
            ### Virtual Reality and Dreams
            
            - VR experiences before sleep may influence dream content
            - VR simulations help recreate and process nightmare scenarios
            - Therapeutic applications for dream-related disorders
            
            ### Dream Sharing and Social Dreaming
            
            - Databases collecting and analyzing thousands of dream reports
            - Communities for sharing and discussing dreams
            - Cultural and cross-geographical dream pattern analysis
            
            As technology continues to advance, we can expect even more sophisticated tools for exploring, recording, and potentially even sharing the mysterious world of dreams.
            """,
            images: ["dream_tech", "brain_scanning", "lucid_devices"]
        )
    ]
}

struct LearnCard: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let isPrimary: Bool
    let isAlternate: Bool
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                // Left part - Icon
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 70, height: 70)
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(primaryPurple)
                }
                
                // Right part - Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            Divider()
                .background(lightPurple)
                .padding(.horizontal, 16)
            
            // Action Button
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: isPrimary ? "play.circle.fill" : "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text(buttonTitle)
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .padding(.horizontal, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(isAlternate ? lightPurple : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(DynamicColors.lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
}

struct SymbolOfTheDay: View {
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("SYMBOL OF THE DAY")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ZStack {
                Circle()
                    .fill(lightPurple)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "questionmark")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text("Question Mark")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("A symbol of mystery and the unknown in dreams")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                // Show more details
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("SHOW MORE")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(DynamicColors.lightPurple, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
    }
}

struct ArticleOfTheDay: View {
    let article: DreamArticle
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedArticle: DreamArticle?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Featured badge and header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    Text("FEATURED TODAY")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(0.5)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    DynamicColors.primaryPurple,
                                    DynamicColors.primaryPurple.opacity(0.8)
                                ]), 
                                startPoint: .leading, 
                                endPoint: .trailing
                            )
                        )
                )
                
                Spacer()
                
                // Date display
                Text(formattedDate())
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(DynamicColors.textSecondary)
            }
            
            // Article card with a more modern design
            Button(action: {
                selectedArticle = article
            }) {
                VStack(alignment: .leading, spacing: 0) {
                    // Abstract header image with rounded top corners
                    AbstractionView(seed: article.id, type: .header)
                        .frame(height: 140)
                        .overlay(
                            // Gradient overlay for better text contrast
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black.opacity(0.5),
                                    Color.black.opacity(0.2),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(
                            // Just round the top corners
                            RoundedRectangle(cornerRadius: 20)
                        )
                        .overlay(
                            // Category badge
                            Text(article.category.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(DynamicColors.primaryPurple.opacity(0.8))
                                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                )
                                .padding(16),
                            alignment: .topTrailing
                        )
                    
                    // Content container with rest of card
                    VStack(alignment: .leading, spacing: 12) {
                        // Icon and title
                        HStack(spacing: 16) {
                            // Article icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                DynamicColors.lightPurple,
                                                DynamicColors.primaryPurple.opacity(0.7)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)
                                    .shadow(color: DynamicColors.primaryPurple.opacity(0.2), radius: 5, x: 0, y: 3)
                                
                                Image(systemName: article.icon)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .offset(y: -30)
                            .padding(.bottom, -30)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(article.title)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                // Reading time indicator
                                HStack(spacing: 4) {
                                    Image(systemName: "clock")
                                        .font(.system(size: 12))
                                        .foregroundColor(DynamicColors.primaryPurple)
                                    
                                    Text("\(estimateReadingTime(article.content)) min read")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(DynamicColors.textSecondary)
                                }
                            }
                        }
                        
                        // Description
                        Text(article.description.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.system(size: 14))
                            .foregroundColor(DynamicColors.textSecondary)
                            .lineSpacing(4)
                            .lineLimit(3)
                            .padding(.trailing, 8)
                        
                        // Read more button
                        HStack {
                            Text("Read Article")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(DynamicColors.primaryPurple)
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(DynamicColors.primaryPurple)
                        }
                        .padding(.top, 4)
                    }
                    .padding(16)
                    .padding(.top, 4)
                    .background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                }
                // Apply corner radius to entire card
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // Helper functions
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: Date())
    }
    
    private func estimateReadingTime(_ content: String) -> Int {
        let wordCount = content.split(separator: " ").count
        let readingTimeMinutes = max(1, Int(ceil(Double(wordCount) / 200.0)))
        return readingTimeMinutes
    }
}

// MARK: - LucidDreamingLessonTile
struct LucidDreamingLessonTile: View {
    @Environment(\.colorScheme) var colorScheme
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("LUCID DREAMING LESSON")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textSecondary)
            
            ZStack {
                Circle()
                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(DynamicColors.primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text("Master Lucid Dreaming")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Generate a unique lesson to improve your lucid dreaming skills")
                .font(.subheadline)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onButtonTap()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("GET LESSON")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
}

// MARK: - DailyDreamFactTile
struct DailyDreamFactTile: View {
    @Environment(\.colorScheme) var colorScheme
    var onButtonTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("DAILY DREAM FACT")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textSecondary)
            
            ZStack {
                Circle()
                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(DynamicColors.primaryPurple)
            }
            .padding(.vertical, 8)
            
            Text("Did You Know?")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(DynamicColors.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Discover a fascinating fact about dreams and sleep science")
                .font(.subheadline)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onButtonTap()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("LEARN FACT")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
}

// MARK: - LucidDreamingLessonDetailView
struct LucidDreamingLessonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var lesson: DreamContent?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var loadingTips = [
        "Reality checks help you recognize when you're dreaming",
        "Writing down dreams improves your dream recall",
        "Lucid dreamers can solve problems during sleep",
        "Sleep paralysis is a common entry point to lucid dreaming",
        "Most lucid dreams occur during REM sleep",
        "Visualization before sleep can trigger lucid dreams"
    ]
    @State private var currentTipIndex = 0
    @State private var loadingProgress = 0.0
    @State private var rotationDegrees = 0.0
    @State private var pulseEffect = false
    @State private var tipOpacity = 1.0
    @State private var contentOpacity = 0.0
    @State private var appearAnimation = false
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    let progressTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Enhanced background with gradient overlay
            DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            // Decorative elements for visual interest
            VStack {
                if !isLoading && lesson != nil {
                    Circle()
                        .fill(DynamicColors.primaryPurple.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .offset(x: 150, y: -50)
                        .blur(radius: 70)
                    
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(0.08))
                        .frame(width: 250, height: 250)
                        .offset(x: -150, y: 300)
                        .blur(radius: 60)
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top navigation bar with enhanced styling
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Text("Lucid Dreaming Lesson")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        // Regenerate lesson with haptic feedback
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        generateNewLesson()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                Divider()
                    .background(DynamicColors.primaryPurple.opacity(0.1))
                
                // Lesson content with improved layout
                ScrollView {
                    VStack(spacing: 24) {
                        if isLoading {
                            VStack(spacing: 32) {
                                // Animated loading icon
                                ZStack {
                                    // Outer pulsing circle
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 0.7))
                                        .frame(width: 120, height: 120)
                                        .scaleEffect(pulseEffect ? 1.1 : 0.95)
                                        .animation(
                                            Animation.easeInOut(duration: 1.5)
                                                .repeatForever(autoreverses: true),
                                            value: pulseEffect
                                        )
                                    
                                    // Inner rotating circle
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.2 : 0.4))
                                        .frame(width: 100, height: 100)
                                        .rotationEffect(.degrees(rotationDegrees))
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "graduationcap.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(DynamicColors.primaryPurple)
                                            .rotationEffect(.degrees(isLoading ? 10 : -10))
                                            .animation(
                                                Animation.easeInOut(duration: 1.0)
                                                    .repeatForever(autoreverses: true),
                                                value: isLoading
                                            )
                                            .shadow(color: DynamicColors.primaryPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                                        
                                        // Animated progress dots
                                        HStack(spacing: 4) {
                                            ForEach(0..<3) { index in
                                                Circle()
                                                    .fill(DynamicColors.primaryPurple)
                                                    .frame(width: 6, height: 6)
                                                    .opacity(currentTipIndex % 3 == index ? 1 : 0.3)
                                                    .animation(.easeInOut, value: currentTipIndex)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 40)
                                
                                Text("Creating your lesson...")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                // Progress bar
                                ProgressView(value: loadingProgress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: DynamicColors.primaryPurple))
                                    .frame(width: 200)
                                
                                // Rotating tips with smooth transition
                                VStack(spacing: 12) {
                                    Text("Did you know?")
                                        .font(.headline)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                    
                                    Text(loadingTips[currentTipIndex])
                                        .font(.body)
                                        .foregroundColor(DynamicColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                        .opacity(tipOpacity)
                                        .id(currentTipIndex) // Forces view refresh on change
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(DynamicColors.backgroundSecondary)
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                )
                                .padding(.horizontal, 24)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .onAppear {
                                // Start animations
                                pulseEffect = true
                                withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                                    rotationDegrees = 360
                                }
                                
                                // Random starting tip
                                currentTipIndex = Int.random(in: 0..<loadingTips.count)
                            }
                            .onReceive(timer) { _ in
                                // Fade out current tip
                                withAnimation(.easeOut(duration: 0.5)) {
                                    tipOpacity = 0
                                }
                                
                                // Wait for fade out, then change tip and fade in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    currentTipIndex = (currentTipIndex + 1) % loadingTips.count
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        tipOpacity = 1
                                    }
                                }
                            }
                            .onReceive(progressTimer) { _ in
                                if loadingProgress < 0.95 {
                                    // Random increments to make it look more natural
                                    loadingProgress += Double.random(in: 0.003...0.01)
                                }
                            }
                        } else if let errorMessage = errorMessage {
                            VStack(spacing: 24) {
                                ZStack {
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(DynamicColors.primaryPurple)
                                }
                                .padding(.top, 60)
                                
                                Text("Unable to Generate Lesson")
                                    .font(.title3)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                                
                                Button(action: {
                                    generateNewLesson()
                                }) {
                                    Text("Try Again")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 12)
                                        .background(DynamicColors.primaryPurple)
                                        .cornerRadius(24)
                                }
                                .padding(.top, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        } else if let lesson = lesson {
                            // Improved content layout with animations and better styling
                            VStack(alignment: .leading, spacing: 28) {
                                // Banner header section with enhanced visual styling
                                VStack(alignment: .center, spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                            .frame(width: 100, height: 100)
                                            .shadow(color: DynamicColors.primaryPurple.opacity(0.2), radius: 10, x: 0, y: 0)
                                        
                                        Image(systemName: "graduationcap.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(DynamicColors.primaryPurple)
                                            .offset(y: appearAnimation ? 0 : 5)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: appearAnimation)
                                    }
                                    .offset(y: appearAnimation ? 0 : -10)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: appearAnimation)
                                    
                                    VStack(spacing: 8) {
                                        Text(lesson.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(DynamicColors.textPrimary)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.horizontal)
                                            .offset(y: appearAnimation ? 0 : 10)
                                            .opacity(appearAnimation ? 1 : 0)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: appearAnimation)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                                
                                // Introduction card with enhanced styling
                                VStack(alignment: .leading, spacing: 0) {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        DynamicColors.primaryPurple.opacity(0.9),
                                                        DynamicColors.primaryPurple.opacity(0.7)
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("INTRODUCTION")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white.opacity(0.9))
                                                
                                                if let intro = lesson.introduction as String?, !intro.isEmpty {
                                                    Text(intro)
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                } else {
                                                    Text("Learn essential techniques to recognize when you're dreaming and take control of your dream experience.")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                }
                                            }
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 20)
                                            
                                            Spacer()
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    
                                    // Remove the full introduction content section and proceed to the lesson sections
                                }
                                .offset(y: appearAnimation ? 0 : 20)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3), value: appearAnimation)
                                
                                // Lesson sections with improved styling and animations
                                if !lesson.sections.isEmpty {
                                    Text("KEY TECHNIQUES")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)
                                        .offset(y: appearAnimation ? 0 : 20)
                                        .opacity(appearAnimation ? 1 : 0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: appearAnimation)
                                    
                                    ForEach(Array(lesson.sections.enumerated()), id: \.element.id) { index, section in
                                        HStack(alignment: .top, spacing: 16) {
                                            // Circle with number
                                            ZStack {
                                                Circle()
                                                    .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                                    .frame(width: 40, height: 40)
                                                
                                                Text("\(index + 1)")
                                                    .font(.headline)
                                                    .foregroundColor(DynamicColors.primaryPurple)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                // Section title
                                                Text(section.heading.replacingOccurrences(of: #"^\d+\.\s*"#, with: "", options: .regularExpression))
                                                    .font(.headline)
                                                    .foregroundColor(DynamicColors.textPrimary)
                                                
                                                // Section content
                                                Text(section.content)
                                                    .font(.body)
                                                    .foregroundColor(DynamicColors.textSecondary)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                        }
                                        .padding(16)
                                        .background(DynamicColors.backgroundSecondary)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                                        .offset(y: appearAnimation ? 0 : 30)
                                        .opacity(appearAnimation ? 1 : 0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4 + Double(index) * 0.1), value: appearAnimation)
                                    }
                                } else {
                                    Text("KEY TECHNIQUES")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.top, 16)
                                        .padding(.bottom, 8)
                                    
                                    // Default section if none provided
                                    HStack(alignment: .top, spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                                .frame(width: 40, height: 40)
                                            
                                            Text("1")
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.primaryPurple)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Reality Checks")
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.textPrimary)
                                            
                                            Text("Perform reality checks throughout the day, such as looking at your hands, checking text, or pushing your finger against your palm. These habits will carry into your dreams, helping you realize when you're dreaming.")
                                                .font(.body)
                                                .foregroundColor(DynamicColors.textSecondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .padding(16)
                                    .background(DynamicColors.backgroundSecondary)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                                }
                                
                                // Conclusion with more appealing visual styling
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("TAKEAWAY")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.bottom, 4)
                                    
                                    Text(lesson.conclusion)
                                        .font(.body)
                                        .italic()
                                        .foregroundColor(DynamicColors.textPrimary)
                                        .lineSpacing(6)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.1 : 0.2)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                                )
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.8), value: appearAnimation)
                                
                                // Practice suggestion card
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "moon.stars.fill")
                                            .foregroundColor(DynamicColors.primaryPurple)
                                        
                                        Text("Practice Tonight")
                                            .font(.headline)
                                            .foregroundColor(DynamicColors.primaryPurple)
                                    }
                                    
                                    Text("Set an intention to remember your dreams tonight and try the techniques you've learned. Keep a dream journal by your bed to record your experiences when you wake up.")
                                        .font(.subheadline)
                                        .foregroundColor(DynamicColors.textSecondary)
                                        .lineSpacing(4)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(DynamicColors.primaryPurple.opacity(0.3), lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                                        )
                                        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
                                )
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.9), value: appearAnimation)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120) // Increased bottom padding to avoid cropping
                            .opacity(contentOpacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    contentOpacity = 1.0
                                }
                                
                                // Trigger staged animations
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    appearAnimation = true
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            generateNewLesson()
        }
    }
    
    private func generateNewLesson() {
        withAnimation(.easeOut(duration: 0.3)) {
            isLoading = true
            contentOpacity = 0
            appearAnimation = false
        }
        errorMessage = nil
        loadingProgress = 0.0
        tipOpacity = 1.0
        
        print("🧠 Starting to generate lucid dreaming lesson...")
        
        Task {
            do {
                let service = OpenAIService()
                print("🧠 Calling generateLucidDreamingLesson()...")
                let newLesson = try await service.generateLucidDreamingLesson()
                print("✅ Successfully generated lesson: \(newLesson.title)")
                
                DispatchQueue.main.async {
                    self.loadingProgress = 1.0
                    
                    // Add a slight delay before showing content for smooth transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.lesson = newLesson
                        
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.isLoading = false
                        }
                        
                        // Add haptic feedback for success
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
            } catch {
                print("❌ Error generating lesson: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                    
                    // Add haptic feedback for error
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
}

// MARK: - DailyDreamFactDetailView
struct DailyDreamFactDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var dreamFact: DreamContent?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var loadingFacts = [
        "The average person has 3-5 dreams per night",
        "Dreams typically last between 5-20 minutes",
        "Everyone dreams, even those who don't remember them",
        "We forget 95% of our dreams shortly after waking",
        "Blind people dream with other senses besides vision",
        "You can't read or tell time accurately in dreams"
    ]
    @State private var currentFactIndex = 0
    @State private var loadingProgress = 0.0
    @State private var glowIntensity = 0.0
    @State private var pulseScale = 1.0
    @State private var factOpacity = 1.0
    @State private var contentOpacity = 0.0
    @State private var rotateBulb = false
    @State private var appearAnimation = false
    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()
    let progressTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Enhanced background with gradient overlay
            DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
            
            // Decorative elements for visual interest
            VStack {
                if !isLoading && dreamFact != nil {
                    Circle()
                        .fill(DynamicColors.primaryPurple.opacity(0.05))
                        .frame(width: 300, height: 300)
                        .offset(x: -150, y: -50)
                        .blur(radius: 70)
                    
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(0.08))
                        .frame(width: 250, height: 250)
                        .offset(x: 150, y: 300)
                        .blur(radius: 60)
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top navigation bar with enhanced styling
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Text("Daily Dream Fact")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        // Regenerate fact with haptic feedback
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        generateNewFact()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(DynamicColors.primaryPurple)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                
                Divider()
                    .background(DynamicColors.primaryPurple.opacity(0.1))
                
                // Fact content with improved layout
                ScrollView {
                    VStack(spacing: 24) {
                        if isLoading {
                            VStack(spacing: 32) {
                                // Animated loading icon with pulsing effect
                                ZStack {
                                    // Outer pulsing glow
                                    Circle()
                                        .fill(DynamicColors.primaryPurple.opacity(glowIntensity))
                                        .frame(width: 140, height: 140)
                                        .blur(radius: 20)
                                    
                                    // Pulsing background
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.4 : 0.8))
                                        .frame(width: 120, height: 120)
                                        .scaleEffect(pulseScale)
                                    
                                    // Main circle
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                        .frame(width: 110, height: 110)
                                    
                                    // Light bulb icon
                                    Image(systemName: "lightbulb.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .rotationEffect(.degrees(rotateBulb ? 10 : -10))
                                        .shadow(color: DynamicColors.primaryPurple.opacity(glowIntensity), radius: 10, x: 0, y: 0)
                                        .overlay(
                                            // Shining lines animation
                                            ZStack {
                                                ForEach(0..<8) { i in
                                                    Rectangle()
                                                        .fill(DynamicColors.primaryPurple)
                                                        .frame(width: 2, height: 12)
                                                        .offset(y: -30)
                                                        .rotationEffect(.degrees(Double(i) * 45))
                                                        .opacity(glowIntensity)
                                                }
                                            }
                                        )
                                }
                                .padding(.top, 40)
                                
                                Text("Discovering an interesting fact...")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                // Progress bar with pulse animation
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(DynamicColors.primaryPurple.opacity(0.2))
                                        .frame(width: 200, height: 6)
                                        .cornerRadius(3)
                                    
                                    Rectangle()
                                        .fill(DynamicColors.primaryPurple)
                                        .frame(width: 200 * loadingProgress, height: 6)
                                        .cornerRadius(3)
                                }
                                
                                // Animated dots
                                HStack(spacing: 6) {
                                    ForEach(0..<3) { index in
                                        Circle()
                                            .fill(DynamicColors.primaryPurple)
                                            .frame(width: 8, height: 8)
                                            .scaleEffect(currentFactIndex % 3 == index ? 1.2 : 0.8)
                                            .opacity(currentFactIndex % 3 == index ? 1 : 0.5)
                                            .animation(.spring(), value: currentFactIndex)
                                    }
                                }
                                
                                // Rotating facts with fade transition
                                VStack(spacing: 12) {
                                    Text("While you wait...")
                                        .font(.headline)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                    
                                    Text(loadingFacts[currentFactIndex])
                                        .font(.body)
                                        .foregroundColor(DynamicColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                        .opacity(factOpacity)
                                        .id(currentFactIndex) // Forces view refresh on change
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(DynamicColors.backgroundSecondary)
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                )
                                .padding(.horizontal, 24)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .onAppear {
                                // Start animations
                                withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                                    glowIntensity = 0.6
                                    pulseScale = 1.1
                                    rotateBulb = true
                                }
                                
                                // Random starting fact
                                currentFactIndex = Int.random(in: 0..<loadingFacts.count)
                            }
                            .onReceive(timer) { _ in
                                // Fade out current fact
                                withAnimation(.easeOut(duration: 0.5)) {
                                    factOpacity = 0
                                }
                                
                                // Wait for fade out, then change fact and fade in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    currentFactIndex = (currentFactIndex + 1) % loadingFacts.count
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        factOpacity = 1
                                    }
                                }
                            }
                            .onReceive(progressTimer) { _ in
                                if loadingProgress < 0.95 {
                                    // Random increments to make it look more natural
                                    loadingProgress += Double.random(in: 0.003...0.01)
                                }
                            }
                        } else if let errorMessage = errorMessage {
                            VStack(spacing: 24) {
                                ZStack {
                                    Circle()
                                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 60))
                                        .foregroundColor(DynamicColors.primaryPurple)
                                }
                                .padding(.top, 60)
                                
                                Text("Unable to Generate Fact")
                                    .font(.title3)
                                    .foregroundColor(DynamicColors.textPrimary)
                                    .multilineTextAlignment(.center)
                                
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                                
                                Button(action: {
                                    generateNewFact()
                                }) {
                                    Text("Try Again")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 32)
                                        .padding(.vertical, 12)
                                        .background(DynamicColors.primaryPurple)
                                        .cornerRadius(24)
                                }
                                .padding(.top, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                            .padding(.bottom, 100) // Added extra padding at bottom
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        } else if let fact = dreamFact {
                            // Improved content layout with animations and better styling
                            VStack(alignment: .leading, spacing: 28) {
                                // Banner header section with enhanced styling
                                VStack(alignment: .center, spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                            .frame(width: 100, height: 100)
                                            .shadow(color: DynamicColors.primaryPurple.opacity(0.2), radius: 10, x: 0, y: 0)
                                        
                                        Image(systemName: "lightbulb.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(DynamicColors.primaryPurple)
                                            .offset(y: appearAnimation ? 0 : 5)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: appearAnimation)
                                    }
                                    .offset(y: appearAnimation ? 0 : -10)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: appearAnimation)
                                    
                                    VStack(spacing: 8) {
                                        Text(fact.title)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(DynamicColors.textPrimary)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.horizontal)
                                            .offset(y: appearAnimation ? 0 : 10)
                                            .opacity(appearAnimation ? 1 : 0)
                                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: appearAnimation)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                                
                                // Introduction banner with enhanced styling
                                VStack(alignment: .leading, spacing: 0) {
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        DynamicColors.primaryPurple.opacity(0.9),
                                                        DynamicColors.primaryPurple.opacity(0.7)
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("DID YOU KNOW?")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white.opacity(0.9))
                                                
                                                if let intro = fact.introduction as String?, !intro.isEmpty {
                                                    Text(intro)
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                } else {
                                                    Text("Dreams are a fascinating window into our subconscious mind, revealing hidden thoughts, emotions, and creativity while we sleep.")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                        .multilineTextAlignment(.leading)
                                                        .lineSpacing(4)
                                                }
                                            }
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 20)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: DynamicColors.primaryPurple.opacity(0.3), radius: 15, x: 0, y: 5)
                                
                                // Remove the full introduction content section
                                
                                // Section divider
                                HStack {
                                    Text("THE SCIENCE")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                    
                                    Spacer()
                                    
                                    Rectangle()
                                        .fill(DynamicColors.primaryPurple.opacity(0.2))
                                        .frame(height: 1)
                                        .frame(maxWidth: .infinity)
                                }
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.4), value: appearAnimation)
                                
                                // Sections with enhanced styling and animations
                                ForEach(Array(fact.sections.enumerated()), id: \.element.id) { index, section in
                                    HStack(alignment: .top, spacing: 16) {
                                        // Circle with number
                                        ZStack {
                                            Circle()
                                                .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                                                .frame(width: 40, height: 40)
                                            
                                            Text("\(index + 1)")
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.primaryPurple)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            // Section title (remove any numeric prefixes)
                                            Text(section.heading.replacingOccurrences(of: #"^\d+\.\s*"#, with: "", options: .regularExpression))
                                                .font(.headline)
                                                .foregroundColor(DynamicColors.textPrimary)
                                            
                                            // Section content
                                            Text(section.content)
                                                .font(.body)
                                                .foregroundColor(DynamicColors.textSecondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .padding(16)
                                    .background(DynamicColors.backgroundSecondary)
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                                    .opacity(appearAnimation ? 1 : 0)
                                    .offset(y: appearAnimation ? 0 : 20)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.5 + Double(index) * 0.1), value: appearAnimation)
                                }
                                
                                // Conclusion with enhanced styling
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("THINK ABOUT IT")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(DynamicColors.primaryPurple)
                                        .padding(.bottom, 4)
                                    
                                    Text(fact.conclusion)
                                        .font(.body)
                                        .italic()
                                        .foregroundColor(DynamicColors.textPrimary)
                                        .lineSpacing(6)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 0.5),
                                                    DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.1 : 0.2)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                                )
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.7), value: appearAnimation)
                                
                                // Share button
                                Button(action: {
                                    // Share functionality
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    
                                    // Create share content
                                    let shareText = "Did you know? \(fact.introduction)\n\nLearn more about dreams with Lunara app!"
                                    let shareContent = [shareText]
                                    
                                    // Get the key window for iOS 13+
                                    let keyWindow = UIApplication.shared.connectedScenes
                                        .filter { $0.activationState == .foregroundActive }
                                        .compactMap { $0 as? UIWindowScene }
                                        .first?.windows
                                        .filter { $0.isKeyWindow }
                                        .first
                                    
                                    // Create activity view controller
                                    let activityViewController = UIActivityViewController(
                                        activityItems: shareContent,
                                        applicationActivities: nil
                                    )
                                    
                                    // Present the activity view controller
                                    if let keyWindow = keyWindow {
                                        keyWindow.rootViewController?.present(
                                            activityViewController,
                                            animated: true,
                                            completion: nil
                                        )
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.headline)
                                        Text("Share This Fact")
                                            .font(.headline)
                                    }
                                    .foregroundColor(DynamicColors.primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1.5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
                                            )
                                    )
                                }
                                .padding(.top, 8)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.8), value: appearAnimation)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120) // Increased bottom padding to avoid cropping
                            .opacity(contentOpacity)
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    contentOpacity = 1.0
                                }
                                
                                // Trigger staged animations
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    appearAnimation = true
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            generateNewFact()
        }
    }
    
    private func generateNewFact() {
        withAnimation(.easeOut(duration: 0.3)) {
            isLoading = true
            contentOpacity = 0
            appearAnimation = false
        }
        errorMessage = nil
        loadingProgress = 0.0
        factOpacity = 1.0
        
        print("💡 Starting to generate daily dream fact...")
        
        Task {
            do {
                let service = OpenAIService()
                print("💡 Calling generateDailyDreamFact()...")
                let newFact = try await service.generateDailyDreamFact()
                print("✅ Successfully generated fact: \(newFact.title)")
                
                DispatchQueue.main.async {
                    self.loadingProgress = 1.0
                    
                    // Add a slight delay before showing content for smooth transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.dreamFact = newFact
                        
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.isLoading = false
                        }
                        
                        // Add haptic feedback for success
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
            } catch {
                print("❌ Error generating fact: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.5)) {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                    
                    // Add haptic feedback for error
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
        }
    }
}

struct EncyclopediaItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                // Left part - Icon
                ZStack {
                    Circle()
                        .fill(lightPurple)
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(primaryPurple)
                }
                
                // Right part - Text
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    Text(subtitle.trimmingCharacters(in: .whitespacesAndNewlines))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
                
                Spacer(minLength: 0)
            }
            .frame(width: 250)
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(DynamicColors.lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
    }
}

struct ArticleCatalogView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedCategories: Set<DreamArticle.ArticleCategory> = []
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    let articles: [DreamArticle]
    
    private var filteredArticles: [DreamArticle] {
        articles.filter { article in
            // Filter by search text
            let matchesSearch = searchText.isEmpty || 
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.description.localizedCaseInsensitiveContains(searchText)
            
            // Filter by selected categories
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(article.category)
            
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search articles...", text: $searchText)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 12)
                
                // Category filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(DreamArticle.ArticleCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                category: category,
                                isSelected: selectedCategories.contains(category),
                                action: {
                                    toggleCategory(category)
                                }
                            )
                        }
                        
                        if !selectedCategories.isEmpty {
                            Button(action: {
                                selectedCategories.removeAll()
                            }) {
                                Text("Clear")
                                    .foregroundColor(primaryPurple)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(primaryPurple, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                
                Divider()
                
                // Results count
                HStack {
                    if filteredArticles.isEmpty {
                        Text("No articles found")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    } else {
                        Text("\(filteredArticles.count) article\(filteredArticles.count == 1 ? "" : "s")")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                if filteredArticles.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No matching articles found")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("Try adjusting your search or filters")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Articles grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredArticles) { article in
                                ArticleGridItem(article: article)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Dream Encyclopedia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(primaryPurple)
                    }
                }
            }
        }
    }
    
    private func toggleCategory(_ category: DreamArticle.ArticleCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

struct CategoryFilterButton: View {
    let category: DreamArticle.ArticleCategory
    let isSelected: Bool
    let action: () -> Void
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : primaryPurple)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? primaryPurple : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(isSelected ? Color.clear : primaryPurple, lineWidth: 1)
                        )
                )
        }
    }
}

struct ArticleGridItem: View {
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    let article: DreamArticle
    
    var body: some View {
        Link(destination: URL(string: article.link)!) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with icon and category
                HStack(alignment: .center) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(lightPurple)
                            .frame(width: 50, height: 50)
                        Image(systemName: article.icon)
                            .font(.system(size: 24))
                            .foregroundColor(DynamicColors.primaryPurple)
                    }
                    
                    Spacer()
                    
                    // Category tag
                    Text(article.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(primaryPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(lightPurple.opacity(0.7))
                        )
                }
                .padding(.top, 8)
                
                // Title
                Text(article.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 4)
                
                // Description
                Text(article.description.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(UIColor.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(DynamicColors.lightPurple, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 4)
        }
    }
}

// New ArticleSheetView to display article content in a modal sheet
struct ArticleSheetView: View {
    let article: DreamArticle
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var scrollOffset: CGFloat = 0
    @State private var showStickyHeader = false
    @State private var appearAnimation = false
    @State private var showFloatingButton = false
    
    // Calculate screen height for dynamic sizing
    @State private var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack(alignment: .top) {
                // Enhanced background with gradient and pattern
                VStack(spacing: 0) {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DynamicColors.backgroundPrimary,
                            DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.05 : 0.1),
                            DynamicColors.backgroundPrimary
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)
                    
                    DynamicColors.backgroundPrimary
                }
                .edgesIgnoringSafeArea(.all)
                
                // Decorative elements
                ZStack {
                    // Top right corner decoration
                    Circle()
                        .fill(DynamicColors.primaryPurple.opacity(0.05))
                        .frame(width: 300)
                        .offset(x: 150, y: -30)
                        .blur(radius: 70)
                    
                    // Bottom left corner decoration
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(0.08))
                        .frame(width: 250, height: 250)
                        .offset(x: -150, y: 400)
                        .blur(radius: 60)
                    
                    // Additional decorative element
                    Circle()
                        .fill(DynamicColors.primaryPurple.opacity(0.05))
                        .frame(width: 200)
                        .offset(x: 100, y: 300)
                        .blur(radius: 50)
                    
                    // Subtle pattern overlay
                    ZStack {
                        ForEach(0..<30) { i in
                            let size = CGFloat.random(in: 3...5)
                            let opacity = Double.random(in: 0.05...0.1)
                            
                            Circle()
                                .fill(DynamicColors.primaryPurple)
                                .frame(width: size, height: size)
                                .offset(
                                    x: CGFloat.random(in: -200...200),
                                    y: CGFloat.random(in: -300...600)
                                )
                                .opacity(opacity)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                
                // Main content scroll view with offset tracking
                ScrollView {
                    // Invisible view to track scroll position
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, 
                                         value: geometry.frame(in: .named("scrollView")).minY)
                    }
                    .frame(height: 0)
                    
                    // Add top padding to account for safe area and status bar
                    Spacer(minLength: 44)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Header with back button and category
                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    dismiss()
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(DynamicColors.primaryPurple)
                                    .padding(8)
                                    .background(
                                        Circle()
                                            .fill(DynamicColors.primaryPurple.opacity(0.1))
                                    )
                            }
                            
                            Spacer()
                            
                            Text(article.category.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(DynamicColors.primaryPurple)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(DynamicColors.primaryPurple.opacity(0.1))
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .opacity(showStickyHeader ? 0 : 1)
                        
                        // Abstract header image with enhanced animation
                        AbstractionView(seed: article.id, type: .header)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .scaleEffect(appearAnimation ? 1 : 0.95)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: appearAnimation)
                            .shadow(color: DynamicColors.primaryPurple.opacity(0.2), radius: 15, x: 0, y: 5)
                        
                        // Article header with improved layout
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .top, spacing: 16) {
                                // Icon with enhanced background
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    DynamicColors.lightPurple,
                                                    DynamicColors.primaryPurple.opacity(0.7)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 70, height: 70)
                                    
                                    Circle()
                                        .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.4))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: article.icon)
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(colorScheme == .dark ? .white : .white)
                                }
                                .shadow(color: DynamicColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 3)
                                .scaleEffect(appearAnimation ? 1 : 0.8)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: appearAnimation)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(article.title)
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(DynamicColors.textPrimary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    // Category indicator with new style
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(DynamicColors.primaryPurple)
                                            .frame(width: 8, height: 8)
                                        
                                        Text(article.category.rawValue)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(DynamicColors.primaryPurple)
                                    }
                                }
                                .offset(x: appearAnimation ? 0 : -10)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.3), value: appearAnimation)
                            }
                            
                            Text(article.description)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(DynamicColors.textSecondary)
                                .lineSpacing(5)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 2)
                                .offset(y: appearAnimation ? 0 : 10)
                                .opacity(appearAnimation ? 1 : 0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4), value: appearAnimation)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        
                        // Reading time indicator with enhanced design
                        HStack(spacing: 12) {
                            // Reading time
                            HStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .font(.footnote)
                                    .foregroundColor(DynamicColors.primaryPurple)
                                
                                Text("\(estimateReadingTime(article.content)) min read")
                                    .font(.footnote)
                                    .foregroundColor(DynamicColors.textSecondary)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                Capsule()
                                    .fill(DynamicColors.primaryPurple.opacity(0.05))
                            )
                            
                            // Word count
                            HStack(spacing: 8) {
                                Image(systemName: "text.word.spacing")
                                    .font(.footnote)
                                    .foregroundColor(DynamicColors.primaryPurple)
                                
                                Text("\(article.content.split(separator: " ").count) words")
                                    .font(.footnote)
                                    .foregroundColor(DynamicColors.textSecondary)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                Capsule()
                                    .fill(DynamicColors.primaryPurple.opacity(0.05))
                            )
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                        .opacity(appearAnimation ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.5), value: appearAnimation)
                        
                        // Content divider
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        DynamicColors.primaryPurple.opacity(0.5),
                                        DynamicColors.lightPurple.opacity(0.3),
                                        DynamicColors.primaryPurple.opacity(0.1)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                            .opacity(appearAnimation ? 1 : 0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.6), value: appearAnimation)
                        
                        // Article content
                        VStack(alignment: .leading, spacing: 24) {
                            // Parse and render content sections
                            ArticleContentView(content: article.content, articleId: article.id)
                        }
                        .padding(.horizontal, 20)
                        .opacity(appearAnimation ? 1 : 0)
                        .animation(.easeIn(duration: 0.6).delay(0.6), value: appearAnimation)
                        
                        // Related topics suggestions
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Related Topics")
                                .font(.headline)
                                .foregroundColor(DynamicColors.textPrimary)
                                .padding(.top, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(getRelatedTopics(), id: \.self) { topic in
                                        Text(topic)
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                            .foregroundColor(DynamicColors.primaryPurple)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule()
                                                    .fill(DynamicColors.primaryPurple.opacity(0.1))
                                            )
                                    }
                                }
                                .padding(.bottom, 8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .opacity(appearAnimation ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.8), value: appearAnimation)
                        
                        // Article footer with share button
                        VStack {
                            Rectangle()
                                .fill(DynamicColors.lightPurple.opacity(0.2))
                                .frame(height: 1)
                                .padding(.vertical, 24)
                            
                            ShareLink(item: "\(article.title)\n\n\(article.description)\n\nLearn more about dreams with Lunara app!") {
                                HStack(spacing: 8) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("SHARE ARTICLE")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(DynamicColors.primaryPurple)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .opacity(appearAnimation ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.9), value: appearAnimation)
                        
                        // Extra bottom padding to ensure content isn't cut off
                        Spacer(minLength: 100)
                    }
                }
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showStickyHeader = value < -50
                        showFloatingButton = value < -200
                    }
                }
                
                // Sticky header with improved design
                VStack {
                    if showStickyHeader {
                        HStack {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    dismiss()
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(DynamicColors.primaryPurple)
                            }
                            
                            Spacer()
                            
                            Text(article.title)
                                .font(.headline)
                                .lineLimit(1)
                                .foregroundColor(DynamicColors.textPrimary)
                            
                            Spacer()
                            
                            Text(article.category.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(DynamicColors.primaryPurple)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(DynamicColors.primaryPurple.opacity(0.1))
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .fill(colorScheme == .dark ? 
                                     Color(UIColor.systemBackground).opacity(0.9) : 
                                     Color.white.opacity(0.95))
                                .background(
                                    Material.ultraThinMaterial
                                )
                                .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 5)
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showStickyHeader)
            }
            
            // Floating action button for sharing
            if showFloatingButton {
                ShareLink(item: "\(article.title)\n\n\(article.description)\n\nLearn more about dreams with Lunara app!") {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        DynamicColors.primaryPurple,
                                        DynamicColors.primaryPurple.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .shadow(color: DynamicColors.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(20)
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showFloatingButton)
            }
        }
        .onAppear {
            // Trigger animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                appearAnimation = true
            }
        }
        // Handle bottom edge rounding and presentation settings
        .background(DynamicColors.backgroundPrimary)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Estimate reading time based on content length
    private func estimateReadingTime(_ content: String) -> Int {
        let wordCount = content.split(separator: " ").count
        let readingTimeMinutes = max(1, Int(ceil(Double(wordCount) / 200.0))) // Average reading speed is ~200 words per minute
        return readingTimeMinutes
    }
    
    // Generate related topics based on article category
    private func getRelatedTopics() -> [String] {
        switch article.category {
        case .science:
            return ["Sleep Cycles", "Neuroscience", "Brain Waves", "Memory", "REM Sleep"]
        case .psychology:
            return ["Dream Analysis", "Carl Jung", "Symbols", "Subconscious", "Therapy"]
        case .techniques:
            return ["Lucid Dreaming", "Dream Recall", "Sleep Hygiene", "Meditation", "Visualization"]
        case .symbols:
            return ["Common Symbols", "Cultural Differences", "Interpretation", "Recurring Themes", "Personal Meaning"]
        case .research:
            return ["Sleep Labs", "Dream Statistics", "Latest Studies", "Technology", "Research Methods"]
        }
    }
}

// Helper extension for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Update LearnView to use sheets for article presentation
struct LearnView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showArticleCatalog = false
    @State private var showDailyRitual = false
    @State private var showLucidDreamingLesson = false
    @State private var showDreamFact = false
    @State private var showSubscription = false
    @State private var searchText: String = ""
    @State private var selectedCategory: DreamArticle.ArticleCategory? = nil
    @State private var expandedArticle: UUID? = nil
    @State private var selectedArticle: DreamArticle? = nil
    @State private var showArticleSheet = false
    @StateObject private var subscriptionService = SubscriptionService.shared
    
    private let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    private let lightPurple = Color(red: 230/255, green: 230/255, blue: 250/255)
    
    private let columns = [
        GridItem(.flexible())
    ]
    
    private var filteredArticles: [DreamArticle] {
        var articles = DreamArticle.allArticles
        
        // Apply category filter if selected
        if let category = selectedCategory {
            articles = articles.filter { $0.category == category }
        }
        
        // Apply search text filter if not empty
        if !searchText.isEmpty {
            articles = articles.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.description.lowercased().contains(searchText.lowercased())
            }
        }
        
        return articles
    }
    
    // Random article for the "Article of the Day" section
    private var articleOfTheDay: DreamArticle {
        DreamArticle.allArticles.randomElement() ?? DreamArticle.allArticles[0]
    }
    
    // Function to handle lucid dreaming lesson tap
    private func handleLucidDreamingLessonTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        if subscriptionService.canViewLucidDreamingLesson() {
            subscriptionService.incrementLucidDreamingLessonAttempts()
            showLucidDreamingLesson = true
        } else {
            showSubscription = true
        }
    }
    
    // Function to handle daily dream fact tap
    private func handleDailyDreamFactTap() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        if subscriptionService.canViewDailyDreamFact() {
            subscriptionService.incrementDailyDreamFactAttempts()
            showDreamFact = true
        } else {
            showSubscription = true
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DynamicColors.backgroundPrimary.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header section with title - fixed at top
                    TopBarView(
                        title: "Learn",
                        primaryPurple: DynamicColors.primaryPurple,
                        colorScheme: colorScheme,
                        rightButtons: [
                            TopBarButton(icon: "questionmark.circle", action: {
                                if let url = URL(string: "https://multumgrp.tech/lunara-help") {
                                    UIApplication.shared.open(url)
                                }
                            })
                        ]
                    )
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Search Bar
                            searchBar
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            // Category Filters
                            categoryFilters
                                .padding(.horizontal, 16)
                            
                            // Lucid Dreaming Lesson Tile
                            NavigationLink(
                                destination: LucidDreamingLessonDetailView(),
                                isActive: $showLucidDreamingLesson
                            ) {
                                Button(action: {
                                    handleLucidDreamingLessonTap()
                                }) {
                                    LucidDreamingLessonTile(onButtonTap: {
                                        handleLucidDreamingLessonTap()
                                    })
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 16)
                            
                            // Daily Dream Fact Tile
                            NavigationLink(
                                destination: DailyDreamFactDetailView(),
                                isActive: $showDreamFact
                            ) {
                                Button(action: {
                                    handleDailyDreamFactTap()
                                }) {
                                    DailyDreamFactTile(onButtonTap: {
                                        handleDailyDreamFactTap()
                                    })
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 16)
                            
                            // Article of the Day
                            ArticleOfTheDay(
                                article: articleOfTheDay,
                                selectedArticle: $selectedArticle
                            )
                                .padding(.horizontal, 16)
                            
                            // Article Grid
                            articleGrid
                                .padding(.horizontal, 16)
                            
                            Spacer(minLength: 80)
                        }
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $selectedArticle) { article in
                ArticleSheetView(article: article)
                    .edgesIgnoringSafeArea(.all)
            }
            .fullScreenCover(isPresented: $showSubscription) {
                SubscriptionView()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DynamicColors.gray3)
            
            TextField("Search articles...", text: $searchText)
                .foregroundColor(DynamicColors.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DynamicColors.gray3)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(DynamicColors.backgroundSecondary)
        )
    }
    
    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All categories option
                CategoryPill(
                    name: "All",
                    isSelected: selectedCategory == nil,
                    action: { selectedCategory = nil }
                )
                
                // Individual category pills
                ForEach(DreamArticle.ArticleCategory.allCases, id: \.self) { category in
                    CategoryPill(
                        name: category.rawValue,
                        isSelected: selectedCategory == category,
                        action: {
                            selectedCategory = category
                        }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    private var articleGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(filteredArticles) { article in
                ArticleCard(
                    article: article,
                    selectedArticle: $selectedArticle
                )
            }
        }
    }
}

struct CategoryPill: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : DynamicColors.primaryPurple)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? DynamicColors.primaryPurple : DynamicColors.primaryPurple.opacity(0.1))
                )
        }
    }
}

struct ArticleCard: View {
    let article: DreamArticle
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedArticle: DreamArticle?
    
    var body: some View {
        Button(action: {
            selectedArticle = article
        }) {
            VStack(alignment: .leading, spacing: 16) {
                // Header with icon and category
                HStack {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                            .frame(width: 40, height: 40)
                        Image(systemName: article.icon)
                            .font(.system(size: 20))
                            .foregroundColor(DynamicColors.primaryPurple)
                    }
                    
                    Spacer()
                    
                    // Category pill
                    Text(article.category.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(DynamicColors.primaryPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(DynamicColors.primaryPurple.opacity(0.1))
                        )
                }
                
                // Title
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(DynamicColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                // Description
                Text(article.description.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.subheadline)
                    .foregroundColor(DynamicColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Read more button
                HStack {
                    Spacer()
                    Text("Read Article")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(DynamicColors.primaryPurple)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(DynamicColors.primaryPurple)
                }
            }
            .padding(16)
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(DynamicColors.primaryPurple.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ArticleListItem: View {
    let article: DreamArticle
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with icon and title
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 1.0))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: article.icon)
                        .font(.system(size: 24))
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(DynamicColors.textPrimary)
                    
                    Text(article.category.rawValue)
                        .font(.subheadline)
                        .foregroundColor(DynamicColors.primaryPurple)
                }
                
                Spacer()
            }
            
            // Description
            Text(article.description)
                .font(.body)
                .foregroundColor(DynamicColors.textSecondary)
                .multilineTextAlignment(.leading)
            
            // Read More button
            Button(action: {
                if let url = URL(string: article.link) {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                    Text("SHOW MORE")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(DynamicColors.primaryPurple)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(DynamicColors.primaryPurple, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .padding(.vertical, 16)
        .modifier(CardStyle())
    }
    
    @Environment(\.colorScheme) var colorScheme
}

// Preference key to track scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// ArticleContentView with abstractions
struct ArticleContentView: View {
    let content: String
    let articleId: UUID
    
    // Helper function to create a UUID from an article ID and index
    private func createSeedUUID(from articleId: UUID, index: Int) -> UUID {
        let seedString = "\(articleId)-\(index)"
        return UUID(uuidString: seedString) ?? articleId
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            let blocks = parseContent(content)
            
            ForEach(Array(blocks.enumerated()), id: \.offset) { index, block in
                if index > 0 && blocks[index-1].type == .header2 && block.type != .header2 && block.type != .header3 {
                    // Add abstraction after level 2 headers
                    let seedUUID = createSeedUUID(from: articleId, index: index)
                    AbstractionView(seed: seedUUID, type: .divider)
                        .padding(.vertical, 16)
                }
                
                switch block.type {
                case .header1:
                    VStack(alignment: .leading, spacing: 10) {
                        Text(block.text)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(DynamicColors.textPrimary)
                            .padding(.top, 32)
                        
                        // Subtle accent under headers
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        DynamicColors.primaryPurple,
                                        DynamicColors.primaryPurple.opacity(0.6),
                                        DynamicColors.primaryPurple.opacity(0.2)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 120, height: 3)
                            .padding(.bottom, 8)
                    }
                    
                case .header2:
                    VStack(alignment: .leading, spacing: 6) {
                        Text(block.text)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(DynamicColors.textPrimary)
                            .padding(.top, 28)
                        
                        // Subtle accent under subheaders
                        Rectangle()
                            .fill(DynamicColors.primaryPurple.opacity(0.2))
                            .frame(width: 60, height: 2)
                            .padding(.bottom, 4)
                    }
                    
                case .header3:
                    Text(block.text)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(DynamicColors.primaryPurple)
                        .padding(.top, 16)
                        .padding(.bottom, 4)
                    
                case .paragraph:
                    Text(block.text)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(DynamicColors.textPrimary)
                        .lineSpacing(8)
                        .padding(.vertical, 4)
                    
                case .bulletPoint:
                    HStack(alignment: .top, spacing: 14) {
                        // Enhanced bullet point style
                        ZStack {
                            Circle()
                                .fill(DynamicColors.lightPurple)
                                .frame(width: 20, height: 20)
                            
                            Circle()
                                .fill(DynamicColors.primaryPurple)
                                .frame(width: 8, height: 8)
                        }
                        .padding(.top, 5)
                        
                        Text(block.text)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(DynamicColors.textPrimary)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.leading, 4)
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.horizontal, 2) // Add a bit of extra padding inside the container
    }
    
    // Simple Markdown parser for the article content
    func parseContent(_ content: String) -> [ContentBlock] {
        var blocks: [ContentBlock] = []
        let lines = content.components(separatedBy: "\n")
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedLine.isEmpty { continue }
            
            if trimmedLine.hasPrefix("# ") {
                blocks.append(ContentBlock(type: .header1, text: String(trimmedLine.dropFirst(2))))
            } else if trimmedLine.hasPrefix("## ") {
                blocks.append(ContentBlock(type: .header2, text: String(trimmedLine.dropFirst(3))))
            } else if trimmedLine.hasPrefix("### ") {
                blocks.append(ContentBlock(type: .header3, text: String(trimmedLine.dropFirst(4))))
            } else if trimmedLine.hasPrefix("- ") {
                blocks.append(ContentBlock(type: .bulletPoint, text: String(trimmedLine.dropFirst(2))))
            } else {
                blocks.append(ContentBlock(type: .paragraph, text: trimmedLine))
            }
        }
        
        return blocks
    }
    
    struct ContentBlock {
        enum BlockType {
            case header1, header2, header3, paragraph, bulletPoint
        }
        
        let type: BlockType
        let text: String
    }
}

// Abstract visual element generator
struct AbstractionView: View {
    let seed: UUID // Use article ID as seed for consistent but unique patterns
    let type: AbstractionType
    @Environment(\.colorScheme) var colorScheme
    
    enum AbstractionType {
        case header // Large header abstraction
        case divider // Smaller section divider
    }
    
    // Colors derived from the app's color scheme
    private var colors: [Color] {
        let baseColors = [
            DynamicColors.primaryPurple,
            DynamicColors.primaryPurple.opacity(0.7),
            DynamicColors.lightPurple,
            DynamicColors.primaryPurple.opacity(0.4),
            Color.white.opacity(0.8)
        ]
        
        if colorScheme == .dark {
            return baseColors.map { $0.opacity($0 == Color.white.opacity(0.8) ? 0.1 : 0.8) }
        }
        
        return baseColors
    }
    
    // Generate a stable random number from seed
    private func random(_ index: Int) -> Double {
        let idString = seed.uuidString
        let total = idString.reduce(index) { result, char in
            return result + Int(char.asciiValue ?? 0)
        }
        return Double(abs(total % 100)) / 100.0
    }
    
    // Helper methods to break down complex expressions
    
    // Calculate circle dimensions
    private func circleSize(for index: Int) -> CGSize {
        let baseSize = 10.0
        let randomFactor = random(index * 3)
        let size = baseSize + randomFactor * 60
        return CGSize(width: size, height: size)
    }
    
    // Calculate offset for elements
    private func elementOffset(baseIndex: Int, multiplier: CGFloat) -> CGPoint {
        let randomX = random(baseIndex) - 0.5
        let randomY = random(baseIndex + 5) - 0.5
        return CGPoint(
            x: randomX * multiplier,
            y: randomY * multiplier
        )
    }
    
    // Calculate line dimensions
    private func lineSize(for index: Int, isHeader: Bool) -> CGSize {
        if isHeader {
            // Header lines
            let width = 3.0 + random(index + 20) * 10
            let height = 20.0 + random(index + 25) * 100
            return CGSize(width: width, height: height)
        } else {
            // Divider lines
            let width = 2.0 + random(index + 20) * 6
            let height = 10.0 + random(index + 25) * 40
            return CGSize(width: width, height: height)
        }
    }
    
    // Calculate shape dimensions
    private func shapeSize(for index: Int) -> CGSize {
        let width = 20.0 + random(index + 55) * 40
        let height = 20.0 + random(index + 60) * 40
        return CGSize(width: width, height: height)
    }
    
    // Calculate rotation angle
    private func rotationAngle(for index: Int, maxAngle: Double) -> Double {
        return random(index) * maxAngle
    }
    
    // Calculate opacity
    private func elementOpacity(baseIndex: Int, minOpacity: Double, range: Double) -> Double {
        return minOpacity + random(baseIndex) * range
    }
    
    // Calculate blur radius
    private func blurRadius(for index: Int) -> CGFloat {
        return random(index) * 5
    }
    
    // Pattern of circles
    private func circlesPattern() -> some View {
        ForEach(0..<5, id: \.self) { index in
            let size = circleSize(for: index)
            let offset = elementOffset(baseIndex: index, multiplier: 300)
            let blur = blurRadius(for: index + 10)
            let opacity = elementOpacity(baseIndex: index + 15, minOpacity: 0.3, range: 0.4)
            
            Circle()
                .fill(colors[index % colors.count])
                .frame(width: size.width, height: size.height)
                .offset(x: offset.x, y: offset.y)
                .blur(radius: blur)
                .opacity(opacity)
        }
    }
    
    // Pattern of lines for header
    private func headerLinesPattern() -> some View {
        ForEach(0..<8, id: \.self) { index in
            let size = lineSize(for: index, isHeader: true)
            let offset = elementOffset(baseIndex: index + 30, multiplier: 300)
            let rotation = rotationAngle(for: index + 40, maxAngle: 180)
            let opacity = elementOpacity(baseIndex: index + 45, minOpacity: 0.2, range: 0.3)
            
            Capsule()
                .fill(colors[(index + 2) % colors.count])
                .frame(width: size.width, height: size.height)
                .offset(x: offset.x, y: offset.y)
                .rotationEffect(Angle.degrees(rotation))
                .opacity(opacity)
        }
    }
    
    // Pattern of lines for divider
    private func dividerLinesPattern() -> some View {
        ForEach(0..<4, id: \.self) { index in
            let size = lineSize(for: index, isHeader: false)
            let offset = elementOffset(baseIndex: index + 30, multiplier: 300)
            let rotation = rotationAngle(for: index + 40, maxAngle: 90)
            let opacity = elementOpacity(baseIndex: index + 45, minOpacity: 0.2, range: 0.3)
            
            Capsule()
                .fill(colors[(index + 2) % colors.count])
                .frame(width: size.width, height: size.height)
                .offset(x: offset.x, y: offset.y)
                .rotationEffect(Angle.degrees(rotation))
                .opacity(opacity)
        }
    }
    
    // Pattern of shapes for header
    private func shapesPattern() -> some View {
        ForEach(0..<3, id: \.self) { index in
            let shapeType = Int(random(index + 50) * 3)
            let size = shapeSize(for: index)
            let offset = elementOffset(baseIndex: index + 65, multiplier: 300)
            let rotation = rotationAngle(for: index + 75, maxAngle: 360)
            let opacity = elementOpacity(baseIndex: index + 80, minOpacity: 0.15, range: 0.3)
            
            Group {
                if shapeType == 0 {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(colors[(index + 1) % colors.count])
                } else if shapeType == 1 {
                    Ellipse()
                        .fill(colors[(index + 1) % colors.count])
                } else {
                    Capsule()
                        .fill(colors[(index + 1) % colors.count])
                }
            }
            .frame(width: size.width, height: size.height)
            .offset(x: offset.x, y: offset.y)
            .rotationEffect(Angle.degrees(rotation))
            .opacity(opacity)
        }
    }
    
    // Base gradient background
    private func gradientBackground() -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        DynamicColors.lightPurple.opacity(colorScheme == .dark ? 0.3 : 0.4),
                        DynamicColors.primaryPurple.opacity(colorScheme == .dark ? 0.2 : 0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    var body: some View {
        let height: CGFloat = type == .header ? 200 : 100
        
        return ZStack {
            // Base gradient
            gradientBackground()
            
            // Pattern 1 - Circles
            circlesPattern()
            
            // Pattern 2 - Lines
            if type == .header {
                headerLinesPattern()
            } else {
                dividerLinesPattern()
            }
            
            // Pattern 3 - Shapes (Only for header)
            if type == .header {
                shapesPattern()
            }
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    LearnView()
} 